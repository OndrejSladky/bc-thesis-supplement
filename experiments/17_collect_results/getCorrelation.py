import pandas as pd
from scipy.stats import pearsonr, spearmanr

if __name__ == "__main__":
    # Specify the path to your TSV file
    file_path = "all_data_notSubsampled_v2.tsv"


    try:
        # Calculate Pearson correlation
        #correlation, p_value = calculate_pearson_correlation(file_path, column1, column2)
        # Load the TSV file into a pandas DataFrame
        df = pd.read_csv(file_path, sep='\t')
        
        colData = "M_xz_bytes" #"enc1_xz_bytes"
        colNorm = "l" # "kmer_count"
        # Check if the specified columns exist in the DataFrame
        if "r" not in df.columns or colData not in df.columns:
            raise ValueError("Specified columns do not exist in the DataFrame.")

        # Extract the specified columns
        dRuns = list(df["r"])
        dnorm = list(df[colNorm])
        dSize = list(df[colData])
        # Normalize
        for i in range(len(dRuns)):
            dRuns[i] /= dnorm[i] 
            dSize[i] /= dnorm[i]
        # Calculate Pearson correlation
        correlation, p_value = pearsonr(dRuns, dSize)

        # Print the result
        print(f"Pearson correlation between 'r / {colNorm}' and '{colData} / {colNorm}': {correlation:.4f}; the p value is {p_value:.4f}")
        # Calculate Spearman correlation
        correlation, p_value = spearmanr(dRuns, dSize)

        # Print the result
        print(f"Spearman correlation between 'r / {colNorm}' and '{colData} / {colNorm}': {correlation:.4f}; the p value is {p_value:.4f}")

    except Exception as e:
        print(f"Error: {e}")
