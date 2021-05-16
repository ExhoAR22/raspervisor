.PHONY: all clean

CC := clang
AR := llvm-ar
OBJCOPY := llvm-objcopy
LD := ld.lld

include cultivar/Cultivar.mk
include raspervisor/Raspervisor.mk

all: cultivar test-binary

cultivar: bin/libcultivar.a
test-binary: bin/kernel8.img

CFLAGS := \
	-Wall \
	-Werror \
	-O1 \
	-flto \
	-ffreestanding \
	-nostdinc \
	-nostdlib \
	--target=aarch64-elf \
	-fno-pic \
	-fshort-wchar \
	-mgeneral-regs-only \
	-g \
	-Icultivar

LDFLAGS := \
	-m aarch64elf \
	-nostdlib \
	-Lbin \
	-static -lcultivar \
	-Tlinker.ld

clean:
	@mkdir -p bin obj
	@rm -r bin obj

bin/kernel8.img: bin/kernel8.elf
	@echo OBJCOPY $@
	@mkdir -p $(@D)
	@$(OBJCOPY) -O binary $< $@

bin/libcultivar.a: $(CULTIVAR_OBJS)
	@echo AR $@
	@mkdir -p $(@D)
	@$(AR) rcs $@ $^

bin/kernel8.elf: $(RASPERVISOR_OBJS) bin/libcultivar.a
	@echo LD $@
	@mkdir -p $(@D)
	@$(LD) $(LDFLAGS) -o $@ $^

$(CULTIVAR_OBJS_C): obj/cultivar/%.c.o: cultivar/%.c
	@echo CC $@
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) -c -o $@ $<

$(CULTIVAR_OBJS_S): obj/cultivar/%.S.o: cultivar/%.S
	@echo CC $@
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) -c -o $@ $<

$(RASPERVISOR_OBJS_C): obj/raspervisor/%.c.o: raspervisor/%.c
	@echo CC $@
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) -c -o $@ $<

$(RASPERVISOR_OBJS_S): obj/raspervisor/%.S.o: raspervisor/%.S
	@echo CC $@
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) -c -o $@ $<
