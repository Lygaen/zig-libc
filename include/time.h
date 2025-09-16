#ifndef __TIME_H__
#define __TIME_H__

#include "stddef.h"

#define CLK_TCK 1000

#define clock_t long
#define time_t INT64_T

struct tm {
    int tm_sec;
    int tm_min;
    int tm_hour;
    int tm_mday;
    int tm_mon;
    int tm_year;
    int tm_yday;
    int tm_isdst;
};

clock_t clock();

double difftime(time_t time1, time_t time2);

time_t mktime(struct tm* time_ptr);

time_t time(time_t* timer);

char *asctime(const struct tm* time_ptr);

char *ctime(const struct tm* time_ptr);

struct tm *gmtime(const time_t *timer);

struct tm *localtime(const time_t *timer);

size_t strftime(char *s, size_t maxsize,
                  const char *format, const struct tm *timeptr);
#endif // __TIME_H__
