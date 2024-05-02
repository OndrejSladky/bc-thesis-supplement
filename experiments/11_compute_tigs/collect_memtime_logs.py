import os

def collect_logs_to_tsv(directory_path, output_file_path):
    header_processed = False
    with open(output_file_path, 'w') as output_file:
        for file_name in os.listdir(directory_path):
            if file_name.endswith('.log'):
                # Extract genome, algorithm, and k from the file name
                parts = file_name.split('.a_')
                genome = parts[0]
                partsTwo = parts[1].split('.k_')
                algorithm = partsTwo[0]
                k = partsTwo[1].split('.')[0]
                
                print(f"{genome}\t{algorithm}\t{k}\t{file_name}")
                # Construct the full path to the file
                full_path = os.path.join(directory_path, file_name)
                
                with open(full_path, 'r') as input_file:
                    lines = input_file.readlines()
                    # Skip the first line, process the second as header (if it's the first file), and the third as data
                    if len(lines) > 2:
                        if not header_processed:
                            output_file.write(f"genome\tS_alg\tk\t{lines[1].strip()}\n")
                            header_processed = True
                        output_file.write(f"{genome}\t{algorithm}\t{k}\t{lines[2]}")
                    
if __name__ == "__main__":
    directory_path = './logs/kamenac/' # Change this to your directory path
    output_file_path = 'tigs_computation_memtime.tsv' # Change this to your desired output file path
    collect_logs_to_tsv(directory_path, output_file_path)
