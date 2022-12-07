#include "Fiber.h"

extern "C" {
typedef struct
  {
    unsigned long fault_address;
    unsigned long regs[31];
    unsigned long sp, pc, pstate;
    long double __reserved[256];
  } mcontext_t1;

typedef struct ucontext_t1
  {
    unsigned long uc_flags;
    struct ucontext_t1 *uc_link;
    stack_t uc_stack;
    sigset_t uc_sigmask;
    mcontext_t1 uc_mcontext;
  } ucontext_t1;

extern int getcontext1 (ucontext_t1 *__ucp);
extern int setcontext1 (const ucontext_t1 *__ucp);
extern int swapcontext1 (ucontext_t1 *__restrict __oucp,
                         const ucontext_t1 *__restrict __ucp);
extern void makecontext1 (ucontext_t1 *__ucp, void (*__func) (void),
                          int __argc, ...);
}

thread_local Fiber* sCurrentFiber{};
thread_local Fiber* leavingFiber{};

Fiber::Fiber(void(*FiberEntryPoint)(void* userParam), void* userParam, void* privateData) : m_privateData(privateData)
{
	ucontext_t1* ctx = (ucontext_t1*)malloc(sizeof(ucontext_t1));
	
	const size_t stackSize = 2 * 1024 * 1024;
	m_stackPtr = malloc(stackSize);

	getcontext1(ctx);
	ctx->uc_stack.ss_sp = m_stackPtr;
	ctx->uc_stack.ss_size = stackSize;
	ctx->uc_link = &ctx[0];
    if (userParam!=nullptr) {
        makecontext1(ctx, (void(*)())FiberEntryPoint, 1, userParam);
    } else {
        makecontext1(ctx, (void(*)())FiberEntryPoint, 0);
    }
	this->m_implData = ctx;
}

Fiber::Fiber(void* privateData) : m_privateData(privateData)
{
	ucontext_t1* ctx = (ucontext_t1*)malloc(sizeof(ucontext_t1));
	getcontext1(ctx);
    makecontext1(ctx, nullptr, 0);
	this->m_implData = ctx;
    ctx->uc_link = ctx;

	m_stackPtr = nullptr;
}

Fiber::~Fiber()
{
	if(m_stackPtr)
		free(m_stackPtr);
	free(m_implData);
}

Fiber* Fiber::PrepareCurrentThread(void* privateData)
{
	cemu_assert_debug(sCurrentFiber == nullptr);
    sCurrentFiber = new Fiber(privateData);
	return sCurrentFiber;
}

void Fiber::Switch(Fiber& targetFiber)
{
    leavingFiber = sCurrentFiber;
    sCurrentFiber = &targetFiber;
	swapcontext1((ucontext_t1*)(leavingFiber->m_implData), (ucontext_t1*)(targetFiber.m_implData));
}

void* Fiber::GetFiberPrivateData()
{
	return sCurrentFiber->m_privateData;
}
