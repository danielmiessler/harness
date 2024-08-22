#!/bin/bash

# Function to display the header
display_header() {

  cat <<EOF
 _   _    _    ____  _   _ _____ ____ ____  
| | | |  / \  |  _ \| \ | | ____/ ___/ ___| 
| |_| | / _ \ | |_) |  \| |  _| \___ \___ \ 
|  _  |/ ___ \|  _ <| |\  | |___ ___) |__) |
|_| |_/_/   \_\_| \_\_| \_|_____|____/____/ 

- A tool for testing the efficacy of your AI prompt and model combinations.
by Daniel Miessler

EOF

}

# Function to run a single instance of the harness
run_single_harness() {
  # Run both prompts in parallel
  (
    (
      cat prompt1.md
      echo "---End of Prompt1---"
      echo "---Start of Input"
      cat input.md
    ) | fabric >output1.md
    echo "This is the end of the combined Prompt 1 and the input provided." >>output1.md
  ) &
  pid1=$!
  (
    (
      cat prompt2.md
      echo "---End of Prompt2---"
      echo "---Start of Input"
      cat input.md
    ) | fabric >output2.md
    echo "This is the end of the combined Prompt 2 and the input provided." >>output1.md
  ) &
  pid2=$!
  echo ""
  echo "Processing both prompts in parallel…"
  echo ""
  # Wait for both background processes to finish
  wait $pid1 $pid2
  echo "Both outputs have been created."
  # Combine the input, prompt 1, and prompt 2
  echo ""
  echo "Judging the output…"
  echo ""
  (
    echo "---Start of Input---"
    cat input.md
    echo "---End of Input---"
    echo "---Start of Output1---"
    cat output1.md
    echo "---End of Output1---"
    echo "Start of Output2---"
    cat output2.md
    echo "End of Output2"
  ) | fabric >test.md
  echo "The above is the combined output of the Input Provided, Prompt1's output, and Prompt2's output, all in one file." >>test.md
  # Judge the output
  (
    echo "---The start of the judging system, which takes the combined Input Provided, Prompt1's output, and Prompt2's output and sends it as the input to the assessment Prompt below.---"
    cat judge_ai_output.md
    echo "---End of the assessment system.---"
    echo "---Start of the content to be tested."
    cat test.md
  ) | fabric >results.md
  echo "Process completed. Results are in output1.md, output2.md, and result.md."
  echo ""
  echo ""
  echo "----- RESULTS -----"
  echo ""
  # Show output1
  echo "Prompt 1's Output:"
  echo ""
  cat output1.md
  echo ""
  echo ""
  # Show output2
  echo ""
  echo "Prompt 2's Output:"
  echo ""
  cat output2.md
  echo ""
  echo ""
  cat results.md
}

# Function to run multiple instances and analyze results
run_multi_harness() {
  local num_runs=$1

  # Function to run harness and extract results
  run_harness_instance() {
    local run_id=$1
    # Redirect stdout to a file and hide all output
    ./harness.sh >"full_result_${run_id}.txt" 2>/dev/null
    # Extract the results section
    sed -n '/^----- RESULTS -----/,$p' "full_result_${run_id}.txt" >"result_${run_id}.txt"
    # Extract key outcomes (assuming they're in the last few lines)
    tail -n 10 "result_${run_id}.txt" >"summary_${run_id}.txt"
  }

  echo "Running $num_runs instances in parallel..."

  # Run harness instances in parallel
  for i in $(seq 1 $num_runs); do
    run_harness_instance $i &
  done

  # Wait for all parallel processes to complete
  wait

  # Display individual run results
  echo "Individual Run Results:"
  echo "----------------------"
  for i in $(seq 1 $num_runs); do
    echo "Run $i:"
    cat "summary_${i}.txt"
    echo "----------------------"
  done

  # Combine all results for analysis
  cat result_*.txt >combined_results.txt

  # Analyze combined results using Fabric
  echo "Performing analysis of all test runs..."
  cat <<EOF | fabric >analysis_result.txt

Analyze the content of all these test runs to determine which prompt performed better overall.


$(for i in $(seq 1 $num_runs); do
    echo "Run $i:"
    cat "summary_${i}.txt"
    echo "----------------------"
  done)


And here are the full combined results from all runs:

$(cat combined_results.txt)

Here is how I want to see the output of your analysis.

EXAMPLE OUTPUT:

- There were X number of runs in total.
- There was X amount of variation between runs (describe how different the ratings were between runs).
- Prompt1 performed better in X out of Y runs.
- Based on this number of wins in that number of runs, it's statistically significant that PromptX is better.
- Here is some additional analysis of the ratings from run to run, along with some deeper analysis of the differences in the ratings and results between them.

(Give analysis here)

- Based on this, Harness concludes that (fill in the blank).

END EXAMPLE OUTPUT

EOF

  # Display analysis result
  echo "Analysis complete. Results:"
  cat analysis_result.txt

  # Clean up temporary files
  rm full_result_*.txt result_*.txt summary_*.txt combined_results.txt
}

# Main script logic
display_header

if [ $# -eq 0 ]; then
  # No arguments, run single instance
  run_single_harness
else
  # Argument provided, run multiple instances
  run_multi_harness $1
fi
