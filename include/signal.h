#ifndef __SIGNAL_H__
#define __SIGNAL_H__

#define sig_atomic_t int

#define SIGINT 2
#define SIGILL 5
#define SIGABRT 6
#define SIGFPE 8
#define SIGSEGV 11
#define SIGTERM 15

#define SIG_ERR 1
#define SIG_DFL 0
#define SIG_IGN 1

void (*signal(int, void (*)(int)))(int);
int raise(int);

#endif // __SIGNAL_H__
