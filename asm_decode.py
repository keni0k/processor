commands = ['addi', 'subi', 'add', 'sub', 'mul', 'div',
            'load', 'store',
            'and', 'xor', 'or', 
            'branch', 'jump_reg', 'jump', 'none']

def dec_to_bin(x, count):
    x_bin = bin(int(x))[2:]
    while (len(x_bin)<count):
        x_bin = '0' + x_bin
    return x_bin

def preproc(line):
        line = line.lower().replace(',', '')
        for id, com in enumerate(commands):
                line = line.replace(com, str(id))
        line = line[0:line.find('#')].replace('r', '')
        two_bites = ''
        for idx, word in enumerate(line.split()):
                if idx < 3:
                        count = 5
                else:
                        count = 9
                two_bites += dec_to_bin(word, count)
        if len(two_bites) == 15:
                two_bites += '000000000'
        return two_bites

with open("asm_prog.txt", "r") as file_in:
        with open("asm.bin", "wb") as file_out:
                line = file_in.readline()
                while line:
                        line = preproc(line)
                        print(line)
                        file_out.write(str(hex(int(line[:8], 2))[2:]+' ').encode('charmap'))
                        file_out.write(str(hex(int(line[8:16], 2))[2:]+' ').encode('charmap'))
                        file_out.write(str(hex(int(line[16:], 2))[2:]+' ').encode('charmap'))
                        line = file_in.readline()
