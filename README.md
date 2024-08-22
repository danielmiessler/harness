<div align="center">

![harness_logo](https://github.com/user-attachments/assets/f4eff8fa-116d-42bc-aa62-7fdcc6ba5c07)

# `harness`

![Static Badge](https://img.shields.io/badge/mission-super_basic_prompt_evals)
<br />
![GitHub top language](https://img.shields.io/github/languages/top/danielmiessler/harness)
![GitHub last commit](https://img.shields.io/github/last-commit/danielmiessler/harness)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

<p class="align center">
<h4><code>harness</code> is a tool for testing the efficacy of prompts and prompt + model combinations.</h4>
</p>

[What and Why](#whatandwhy) •
[Installation](#Installation) •
[Usage](#Usage) •
[Examples](#examples) •

</div>

## Navigation

- [What and Why](#what-and-why)
- [Installation](#Installation)
- [Usage](#Usage)
- [Examples](#examples)

<br />

> [!NOTE] 
August 21, 2024 — This is brand new and there will be lots of updates coming soon.

## What and Why

I made this silly little tool because I'm tired of wondering, subjectively, if one prompt works better than another one. I want a way to test them against eah other. So that's what this is.

## Installation

1. First install [Fabric](https://github.com/danielmiessler/fabric), which is another project of ours. To install Fabric, [make sure Go is installed](https://go.dev/doc/install), and then run the following command.

```bash
# Install Fabric directly from the repo
go install github.com/danielmiessler/fabric@latest

# Run the setup to set up your directories and keys
fabric --setup
```

### Environment Variables

If everything works you are good to go, but you may need to set some environment variables in your `~/.bashrc` or `~/.zshrc` file. Here is an example of what you can add:

```bash
# Golang environment variables
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$HOME/.local/bin:$PATH:
```
2. Then once `fabric` runs fine, you're pretty much done. `harness` just runs Fabric using `Bash`.

## Usage

To use `harness`, just do the following:

1. Clone this repo.
2. `cd $your_harness_directory`
3. Put your input in `input.md` (like the transcript you're analyzing, or whatever)
4. Put your first prompt in `prompt1.md`.
5. Put your second prompt in `prompt2.md`.
6. Run `./harness.sh`.

### Multi-mode

Harness has a cool feature where you can try mulitple runs and do analysis on the full set of results (because LLMs have a lot of various from run to run).

To do that, just add a number to the end of the command.

```bash
./harness.sh 10
```

Now you should be able to see which is better across multiple runs, and if you don't see much of a difference across like 10 runs, the differences are probably pretty small.

Enjoy!

## NOTES

> [!CAUTION] 
There is no security or input validation of any kind on this thing. It's a shell script, so like don't put this in production or anything.

