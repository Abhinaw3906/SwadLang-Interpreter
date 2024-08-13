# SwadLang Interpreter 

*Note - at some places it's written as SwedLang Also, consider both as same.

<img width="944" alt="logo" src="https://github.com/user-attachments/assets/b8cff25e-022e-4236-b4d8-3cc3f78d0ca1">




SwedLang is an innovative programming language that bridges natural language processing with high-level programming. This repository contains the SwedLang interpreter implementation.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [SwedLang GPT](#swedlang-gpt)
- [Features](#features)
- [Contributing](#contributing)
- [License](#license)

## Installation

Follow these steps to set up SwedLang on your Windows machine using WSL 2 and Ubuntu.

<details>
<summary><b>Click to expand installation instructions</b></summary>

### 1. Install WSL 2 and Ubuntu

1. Open PowerShell as Administrator and run:
   ```powershell
   wsl --install -d Ubuntu
   ```
2. Restart your computer if prompted.

### 2. Set up OCaml

Open Ubuntu terminal and run:

```bash
sudo apt update
sudo apt install ocaml opam
opam init
eval $(opam env)
```

### 3. Navigate to Your Project Directory

```bash
cd /mnt/c/Users/YourUsername/Documents/SwedLang
```

### 4. Compile SwedLang

```bash
ocamlc -o swedlang swedLang.ml
```

</details>

## Usage

After installation, you can run SwedLang using:

```bash
./swedlang
```

Here are some example SwedLang commands:

```swedlang
Exempel 1: 2 + 3 * 4 - 6 / 2
Resultat: 11

Exempel 2: lat x = 2 i lat y = x + 3 i x * y
Resultat: 10

Exempel 3: om 1 da 100 annars 200
Resultat: 100

Exempel 4: om 5 = 5 da 10 annars 20
Resultat: 10

Exempel 5: om 1 da (om 0 da 100 annars 50) annars 25
Resultat: 50

Exempel 6: om 5 > 3 da 10 annars 20
Resultat: 10
```

## SwedLang GPT

Experience our AI-powered SwedLang interpreter:

[![Try SwedLang GPT](https://img.shields.io/badge/Try%20SwedLang%20GPT-FF6600?style=for-the-badge&logo=openai&logoColor=white)](https://chatgpt.com/g/g-uc15KXNL6-swedlang-interpreter)

1. Visit the [SwedLang Interpreter GPT](https://chatgpt.com/g/g-uc15KXNL6-swedlang-interpreter)
2. Input prompts in natural language
3. Receive SwedLang code output

Note and acknowledgement - I thank **Dr. Nachiket Tapas** for providing access to ChatGPT Premium Subscription because of which i was able to use GPT Store.

## Features

- [x] Natural language to SwedLang code conversion
- [x] Arithmetic and Logical Operations
- [x] Conditional Statements
- [x] Variable Bindings and Scoping
- [ ] File I/O operations (Coming soon)
- [ ] Object-oriented programming support (In development)

## Contributing

We welcome contributions to SwedLang! Here's how you can help:

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a pull request


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

---

<div align="center">
  <h3>SwedLang: Bridging Natural Language and Programming</h3>
</div>
