import mmap


mem_file = os.open("/dev/mem",os.O_SYNC)
mapped_memory = mmap.mmap(mem_file,4,mmap.MAP_PRIVATE, mmap.PROT_READ | mmap.PROT_WRITE, 0,0x43C00000) 
mapped_memory.read(4)
mapped_memory.seek(0)
mapped_memory.write(b'0x1') 
mapped_memory.seek(0)
mapped_memory.read(4)
