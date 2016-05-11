python3 beinecke.py "Pound, Ezra" pound.csv pound_data.csv
python3 beinecke.py "H.D. (Hilda Doolittle)" hd.csv hd_data.csv
python3 beinecke.py "Stein, Gertrude" stein.csv stein_data.csv
python3 beinecke.py "Williams, William Carlos" williams.csv williams_data.csv
rm beinecke.csv
echo "V1,V2,weight" > beinecke.csv
cat *_data.csv >> beinecke.csv

