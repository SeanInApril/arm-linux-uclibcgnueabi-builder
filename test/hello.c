/*
 * hello.c
 *
 * Sean<SeanInApril@163.com>
 *
 * test routine
 */
#include <stdio.h>

int fun(int a, int b)
{
    volatile int c;

    c = a << b;

    return c;
}

int main(void)
{
    int i;

    printf("hello world!\r\n");

    i = fun(100, 3);
    printf("i=%d\r\n", i);

    return 0;
}
