#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>

typedef long long int u64;

int main(int argc, char **argv) {
    printf("Hello World\n");


    /* IP addresses definition */
    unsigned int axi_size = 0x10000;
    off_t axi_pbase = 0x43C00000; /* physical base address */
    u64 *axi_vptr;
    int fd;


    int value = 0x1;


    if ((fd = open("/dev/mem", O_RDWR | O_SYNC)) == -1) {
        printf("Access memory error");
        return(0);
    }

    axi_vptr = (u64 *)mmap(NULL, axi_size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, axi_pbase);

    axi_vptr[0] = 0xDEADBEEF;
    axi_vptr[1] = 0xDEADBEEF;
    axi_vptr[2] = 0xDEADBEEF;
}
