#include <hardware/uart0.h>

void main(uint64_t dtb, uint64_t reserved0, uint64_t reserved1, uint64_t reserved2) {
    dtb &= 0xffffffff;
    uart0_init();
    uart0_puts("Raspervisor\n");
}
