import numpy as np

def hex_to_number(hex):
    number = int(hex, 16)
    if(number>127):
        number = number - 256
    return number

def read_result_mem(fileName = "result_mem.csv", row=1024):
    shape = (row, 512)
    array = np.zeros(shape).astype(np.int8)
    f = open(fileName, "r")
    for i in range(row):
        for j in range(64):# 512/8
            for k in range(8):
                tmpc = f.read(2)
                array[i][8*j+k] = hex_to_number(tmpc)
                # print(tmpc)
                if k==7:
                    if f.read(1) != '\n':
                        print("read error")
    # print('reading matrix:\n',array)
    return array

# main entry
def main():
    # get original input matrix
    array = read_result_mem(fileName = "input_mem.csv",row=1024)
    array0 = np.load("in.npy")
    if np.array_equal(array, array0):
        print("Correct!")
    a1 = array[0:512,:]
    a2 = array[512:1024,:]

    # get computed results from Verilog
    correct_result = np.matrix(a1).astype(int)*np.matrix(a2).astype(int)
    print(f"a1:\n{a1}\na2:\n{a2}\ncorrect_result:\n{correct_result}")

    # check results is correct
    result_array = np.zeros((512,512)) #tmp，请换成你的结果(下一行代码)
    # result_array = read_result_mem(fileName = "result_mem.csv",row=512)
        
    loss = np.sum(np.square(correct_result-result_array)) #mean-square error
    relative_loss = np.sum(np.square(correct_result-result_array))/np.sum(np.square(correct_result)) #relative mean-square error
    print(f">>loss is {loss}\n>>relative_loss is {relative_loss}")

if __name__=="__main__": 
    main()
