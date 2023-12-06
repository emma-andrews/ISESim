
#include <iostream>
#include <vector>
#include <fstream>
#include <string>
#include <random>
#include <stdint.h>
#include <bitset>
#include <iomanip>
#include <cstdlib> 

#define ITERATIONS 10
#define PBSTR "------------------------------------------------------------"
#define PBWIDTH 60

// print pregress
void printProgress(double percentage) {
    int val = (int) (percentage * 100);
    int lpad = (int) (percentage * PBWIDTH);
    int rpad = PBWIDTH - lpad;
    printf("\r%3d%% [%.*s%*s]", val, lpad, PBSTR, rpad, "");
    fflush(stdout);
}

// Function to generate a random 64-bit number with a specific Hamming weight
template <typename T>
T distHw(int weight, std::mt19937_64& gen) {
    T result = 0;
    constexpr int bitWidth = sizeof(T) * 8;
    for (int i = 0; i < weight; ++i) {
        int bitPosition = std::uniform_int_distribution<int>(0, bitWidth - 1 - i)(gen);
        result |= (T(1) << bitPosition);
    }
    return result;
}

// Function to calculate the Hamming weight of a value
int hammingWeight(uint64_t value) {
    int weight = 0;
    while (value > 0) {
        weight += value & 1;
        value >>= 1;
    }
    return weight;
}

int findMaxCSV(const std::vector<int>& data) {
    if (data.empty()) {
        std::cerr << "Empty data vector." << std::endl;
        return -1; // You can handle this case differently based on your requirements.
    }

    int max = data[0];

    for (int value : data) {
        if (value > max) {
            max = value;
        }
    }

    return max;
}

int main(int argc, char **argv) {

    // Initialize random number generator
    std::random_device rd;
    std::mt19937 gen(rd());

    std::mt19937_64 generator(std::random_device{}());
    std::uniform_int_distribution<uint64_t> dis64(0,64);
    std::uniform_int_distribution<uint64_t> dis32(0,32);
    std::uniform_int_distribution<uint64_t> dis4(0,4);    
    std::uniform_int_distribution<uint64_t> dis2(0,2);

    // Check if the correct number of command-line arguments is provided
    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " <compiled_simulator> <fu-name>" << std::endl;
        return 1;
    }

    // Retrieve the output file name from command-line arguments
    std::string socName = argv[1];
    std::string fuName = argv[2];
    
    // Open a CSV file for writing
    std::ofstream csvFile( "../" + socName +"-" + fuName + ".csv");

    ADD_HEADER_TO_CSV();

    std::cout << "\033[0;32mSimulating the SoC \033[0m" << std::endl;
    // Simulate for N iterations
    for (int i = 0; i < ITERATIONS; i++) {

		std::ofstream outputFile("data.S");
    	// Output the .data section
    	outputFile << ".data" << std::endl;

        // Assign random values to inputs
        SET_RAND_VALS();

		// Close the output file
    	outputFile.close();

		// Invoke the make firmware
        int makeResult = std::system("make -s -C ../ compile FW_SRC=obj_dir/firmware.S HEXNAME=rom.hex");
        
        // Check the result of the make command
        if (makeResult != 0) {
            std::cerr << "Error: make command failed." << std::endl;
            return 1;  // You might want to handle the error accordingly
        }

        // Invoke the simulation
        std::string command = "./" + socName + " +q +WAVES=sim.vcd +TIMEOUT=1000 +PASS_ADDR=0x10000066 >> sim.log";
        int socRun = std::system(command.c_str());   

        // Check the result of the make command
        if (socRun != 0) {
            std::cerr << socRun <<"Error: make command failed." << std::endl;
            return 1;  // You might want to handle the error accordingly
        }
        else {
            int toggleResult = std::system("./toggle");
        
            // Check the result of the make command
            if (toggleResult == 0) {
                std::ifstream file("toggle.csv");

                std::vector<int> data;
                std::string line, value;

                // Skip the header
                std::getline(file, line);

                while (std::getline(file, value)) {
                    data.push_back(std::stoi(value));
                }

                file.close();
                std::system("rm toggle.csv");

                int maxValue = findMaxCSV(data);
                
                ADD_ROW_TO_CSV();

            }

            
        }
        printProgress((double) i/(double)(ITERATIONS));
    }
    printProgress((double) 1);
    std::cout << "\n";
    csvFile.close();

    return 0;
}
