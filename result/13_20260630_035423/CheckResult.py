import numpy as np

def hex_to_number(hex_text):
    hex_text = hex_text.strip().lower()
    if len(hex_text) != 2:
        return 0
    number = int(hex_text, 16)
    if(number>127):
        number = number - 256
    return number

def hex_to_int32(hex_text):
    hex_text = hex_text.strip().lower()
    if len(hex_text) != 8:
        return 0
    number = int(hex_text, 16)
    if number >= (1 << 31):
        number = number - (1 << 32)
    return number

def read_result_mem(fileName = "result_mem.csv", row=1024):
    shape = (row, 512)
    array = np.zeros(shape).astype(np.int8)
    with open(fileName, "r") as f:
        lines = [line.strip() for line in f.readlines() if line.strip()]

    expected_lines = row * 64
    if len(lines) < expected_lines:
        raise RuntimeError(f"{fileName} line count too small: got {len(lines)}, expected {expected_lines}")

    line_idx = 0
    for i in range(row):
        for j in range(64):# 512/8
            word = lines[line_idx].rjust(16, "0")[-16:]
            line_idx += 1
            for k in range(8):
                tmpc = word[2*k:2*k+2]
                array[i][8*j+k] = hex_to_number(tmpc)
    return array

def read_result_mem_i32(fileName = "result_mem.csv", row=512):
    shape = (row, 512)
    array = np.zeros(shape).astype(np.int32)
    with open(fileName, "r") as f:
        lines = [line.strip() for line in f.readlines() if line.strip()]

    expected_lines = row * 256
    if len(lines) < expected_lines:
        raise RuntimeError(f"{fileName} line count too small: got {len(lines)}, expected {expected_lines}")

    line_idx = 0
    for i in range(row):
        for j in range(256):
            word = lines[line_idx].rjust(16, "0")[-16:]
            line_idx += 1
            array[i][2*j] = hex_to_int32(word[0:8])
            array[i][2*j+1] = hex_to_int32(word[8:16])
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
    correct_result = np.matmul(a1.astype(np.int32), a2.astype(np.int32))

    # check results is correct
    result_array = read_result_mem_i32(fileName = "result_mem.csv",row=512)
        
    diff = correct_result - result_array
    loss = np.sum(np.square(diff))
    relative_loss = loss/np.sum(np.square(correct_result))
    nonzero_mask = correct_result != 0
    zero_mismatch = np.count_nonzero((correct_result == 0) & (diff != 0))
    if zero_mismatch:
        sse = np.inf
    else:
        sse = np.sum(np.square(diff[nonzero_mask] / correct_result[nonzero_mask]))
    print(f">>loss is {loss}\n>>relative_loss is {relative_loss}\n>>sse is {sse}")

if __name__=="__main__": 
    main()
