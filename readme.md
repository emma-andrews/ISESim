## ㊙️ Cleo: Cryptographic Leakage Evaluation of Hardware

Cleo is a Test Vector Leakage Assessment (TVLA) project that evaluates hardware implementations of cryptographic instruction set extensions for physical side-channel leakage. The current framework supports evaluating ongoing RISC-V cryptography extension standardization work. This is a complete power side-channel evaluation framework parallel to the existing test-based [functional validation suite](https://github.com/riscv/riscv-crypto/) and [formal verification suite](https://github.com/riscv/riscv-crypto/). 


The RISC-V instruction set architecture is known for its open-source and customizable design. One of the notable features of RISC-V is its modular and extensible nature, allowing developers to add custom instructions and extensions tailored to specific applications. There are several ongoing works on developing cryptographic instruction set extensions of RISC-V architecture. 

- [riscv-crypto](https://github.com/riscv/riscv-crypto/): RISC-V cryptography extensions standardisation work.
- [xcrypto](https://github.com/scarv/xcrypto): a cryptographic ISE for RISC-V


### Test Vector Leakage Assessment (TVLA)

Test vector leakage assessment tries to quantify potential power side-channel leakage of a hardware implementation at an early stage design life cycle. The device's power consumption fluctuates as it executes computations, responding to changing logic states and data processing. These current variations generate distinct patterns that enable the analysis of the ongoing operations. By observing these power consumption fluctuations and correlating them with specific computations, an adversary can deduce sensitive data, such as cryptographic keys or plaintext, without needing direct access to the internal memory or processes of the target device.




### Project Structure

Here is the project structure. All the extensions under testing (```eut```) are initialized as submodules. Currenlty,  [riscv-crypto](https://github.com/riscv/riscv-crypto/), [xcrypto](https://github.com/scarv/xcrypto) and [scarv-soc](https://github.com/scarv/scarv-soc) are elvaluated.


```bash
.
├── docker
│   └── dockerfile # Environement
├── eut # extensions under test
│   ├── riscv-crypto
│   ├── scarv-soc
│   └── xcrypto
├── evaluator # evaluator core
│   ├── generator 
│   ├── Makefile # make to run all
│   ├── power_libs # common utility files
│   ├── results.txt # Summary
│   ├── riscv_crypto_fu_saes32
│   ├── riscv_crypto_fu_saes64
│   ├── riscv_crypto_fu_ssha256
│   ├── riscv_crypto_fu_ssha512
│   ├── xc_sha256
│   ├── xc_sha512
│   ├── xc_aessub
│   ├── xc_aesmix
│   └── scarv_soc # SoC for the xcrypto
└── readme.md # You are looking at it
```

### Running CLEO 🏃‍♀️

Following are the steps to run the framework. [Docker](https://www.docker.com/get-started/) is a pre-requisite for Cleo since the complete environment for building everything is provided in [archfx/cleo](https://hub.docker.com/repository/docker/archfx/cleo/general) container.

1. Clone the project repository
```shell
git clone https://github.com/Archfx/Cleo  cleo
```
2. Use the following commands to initiate submodules
```shell
cd cleo
git submodule update --init
git submodule update --init --recursive  eut/scarv-soc
```
3. Pull the docker container and mount the project (You should be inside the project directory)
```shell
docker pull archfx/cleo
docker run -t -p 6080:6080 -v "${PWD}/:/cleo" -w /cleo --name cleo archfx/cleo
```
4. Access the docker container
```shell
docker exec -it cleo /bin/bash
```
5. Finally run Cleo
```shell
cd evaluator && make
```

### Pre-Silicon Side Channel Evaluation of RISCV-CRYPTO ISE

Original implementations of the hardware functional units of RISCV-CRYPTO have a strong correlation with the input values. As an example following is the power side channel signature of the [ssha512](https://github.com/riscv/riscv-crypto/blob/e2dd7d98b7f34d477e38cb5fd7a3af4379525189/rtl/crypto-fu/riscv_crypto_fu_ssha512.v) functional unit and the visual relationship between the input values. Evaluation results of other components are available in ```evaluator``` folder.


<p align="center">
<!--   <img  src="/evaluator/riscv_crypto_fu_ssha512/riscv_crypto_fu_ssha512.svg"> -->
  <img  src="https://raw.githubusercontent.com/Archfx/Cleo/main/evaluator/riscv_crypto_fu_ssha512/riscv_crypto_fu_ssha512.svg?token=GHSAT0AAAAAAB6X4FFY6WNG4GAZNOV7ZUSOZM23D7A">
  <p align="center">
   <em>riscv_crypto_fu_ssha512 power signature compared with the inputs</em>
   </p>
</p>

### Pre-Silicon Side Channel Evaluation of XCRYPTO ISE


#### Functional Unit Evaluation
Original implementations of the hardware functional units of XCRYPTO have a strong correlation with the input values.
As an example following is the power side channel signature of the [xc_sha256](https://github.com/scarv/xcrypto/blob/9ff3426a9d498bf41880caca4bc3769eec0e5093/rtl/xc_sha256/xc_sha256.v) functional unit and the visual relationship between the input values.  Evaluation results of other components are available in ```evaluator``` folder.


<p align="center">
<!--   <img  src="/evaluator/xc_sha256/xc_sha256.svg"> -->
  <img  src="https://raw.githubusercontent.com/Archfx/Cleo/main/evaluator/xc_sha256/xc_sha256.svg?token=GHSAT0AAAAAAB6X4FFYE7FJGAQKEDLOMVG2ZM23E2Q">
  <p align="center">
   <em>xc_sha256 power signature compared with the inputs</em>
   </p>
</p>

#### System Evaluation with SCARV_SOC

XCYPTO ISE is implemented in the SOC implementation of [scarv-soc](https://github.com/scarv/scarv-soc). Therefore all the supporting functional units that are implemented on the scarv-soc are evaluated with the Cleo. Note that system evaluation takes a considerable amount of run time. However, there is a clearly visible statistical significance in the correlation between the input and the observed power values of the system.


<p align="center">
<!--   <img  src="/evaluator/xc_aesmix/Vscarv_soc-xc_aesmix.svg"> -->
  <img  src="https://raw.githubusercontent.com/Archfx/Cleo/main/evaluator/xc_aesmix/Vscarv_soc-xc_aesmix.svg?token=GHSAT0AAAAAAB6X4FFYDXVJBILAY2UIH5K2ZM23F7A">
  <p align="center">
   <em>Power signature of xc_aesmix on the system evaluation compared with the inputs</em>
   </p>
</p>

### Cite this Work
```tex
@misc{cryptoeprint:2024/932,
      author = {Aruna Jayasena and Richard Bachmann and Prabhat Mishra},
      title = {{CISELeaks}: Information Leakage Assessment of  Cryptographic Instruction Set Extension Prototypes},
      howpublished = {Cryptology ePrint Archive, Paper 2024/932},
      year = {2024},
      note = {\url{https://eprint.iacr.org/2024/932}},
      url = {https://eprint.iacr.org/2024/932}
}
```
### LICENCE
Copyright (c) 2023 original authors

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
