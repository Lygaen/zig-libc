#ifndef __SIGNAL_H__
#define __SIGNAL_H__

#define sig_atomic_t int

#define SIGABRT 0
#define SIGFPE 1
#define SIGILL 2
#define SIGINT 3
#define SIGSEGV 4
#define SIGTERM 5

#define SIG_ERR 1
#define SIG_DFL 0
#define SIG_IGN 1

void (*signal(int, void (*)(int)))(int);
int raise(int);

#endif // __SIGNAL_H__
