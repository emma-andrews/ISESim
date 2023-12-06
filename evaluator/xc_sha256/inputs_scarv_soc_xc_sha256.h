#define ADD_HEADER_TO_CSV() \
        csvFile << "hw(rs1),HW" << std::endl;

#define SET_RAND_VALS() \
        uint32_t randomValue_1 = distHw<uint32_t>(dis32(gen), generator); \
        outputFile << "    value_1:   .word   0x" << std::hex << randomValue_1 << std::endl; \
        outputFile << "    value_2:   .word   0x" << std::hex << randomValue_1 << std::endl;

#define ADD_ROW_TO_CSV() \
        csvFile << hammingWeight(randomValue_1) << "," << maxValue << std::endl;
