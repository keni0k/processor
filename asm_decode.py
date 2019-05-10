commands = ['addi', 'subi', 'add', 'sub', 'mul', 'div',
            'load', 'store',
            'and', 'xor', 'or', 
            'branch', 'jump', 'exit', 'mod']

def dec_to_bin(x, count):
    x_bin = bin(int(x))[2:]
    while (len(str(x_bin)) < count):
        x_bin = '0' + x_bin
    return x_bin

def preproc(line):
        line = line.lower().replace(',', '')
        for id, com in enumerate(commands):
                line = line.replace(com, str(id))
        line = line[0:line.find('#')].replace('r', '')
        three_bytes = ''
        for idx, word in enumerate(line.split()):
                if idx < 3:
                        count = 4 + idx
                else:
                        count = 10
               	if idx == 2:
               			count -=1
                if idx == 2 and three_bytes.startswith('0110'):
                		count +=3
                three_bytes += dec_to_bin(word, count)
        while len(three_bytes) < 24:
                three_bytes += '0'
        return three_bytes

with open("asm_prog.txt", "r") as file_in:
        with open("asm.bin", "wb") as file_out:
                line = file_in.readline()
                while line:
                        line = preproc(line)
                        if '1' not in line:
                        	line = file_in.readline()
                        	continue
                        print(line)
                        file_out.write(str(hex(int(line[:8], 2))[2:]+' ').encode('charmap'))
                        file_out.write(str(hex(int(line[8:16], 2))[2:]+' ').encode('charmap'))
                        file_out.write(str(hex(int(line[16:], 2))[2:]+' ').encode('charmap'))
                        line = file_in.readline()