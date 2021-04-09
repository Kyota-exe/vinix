import lib
import memory
import stivale2
import x86

pub fn kmain(stivale2_struct &stivale2.Struct) {
	// Initialize the earliest arch structures.
	x86.gdt_init()
	x86.idt_init()

	// Fetch required tags.
	fb_tag := unsafe { &stivale2.FBTag(stivale2.get_tag(stivale2_struct, stivale2.framebuffer_id)) }
	memmap_tag := unsafe { &stivale2.MemmapTag(stivale2.get_tag(stivale2_struct, stivale2.memmap_id)) }
	if fb_tag == 0 || memmap_tag == 0 {
		lib.panic_kernel('Could not fetch all the required tags')
	}

	// Initialize the memory allocator.
	memory.physical_init(memmap_tag)

	mut framebuffer := &u32(fb_tag.addr)

	for i := 0; i < 250; i++ {
		unsafe {
			framebuffer[i + (fb_tag.pitch / 4) * 2 * i] = 0xffffff
			framebuffer[500 - i + (fb_tag.pitch / 4) * 2 * i] = 0xffffff
		}
	}

	lib.panic_kernel('End of kernel')
}