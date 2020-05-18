# Processing HuBMAP Cell Set Annotations

columns:
- cell name: The cell barcode label from each experiment
- annotation: Our predicted annotation. Each value is a term from the EBI Cell Ontology
- prediction score: Confidence level in prediction, ranging from 0..1
- dataset ID: Links to the dataset IDs from the Loaded Dataset Information HuBMAP google sheet. An example entry is HBM336.FWTN.636
- Globus ID: corresponds to the directory on Globus where the original input data was uploaded (for example, 2dca1bf5832a4102ba780e9e54f6c350)


## Setup

```sh
conda env create -f environment.yml
conda activate hubmap-cell-sets
```

## Run

```sh
snakemake --cores 1
```

## Serve

```sh
yarn global add serve
serve -l 9090
```



## EBI Cell Ontology API

To find the ancestors of `B cell`, for example:

```
https://www.ebi.ac.uk/ols/api/select?q=B%20cell
```

in `.response.docs[]` find the first result with the matching `.label` and `.ontology_name == "cl"`, and obtain its `.iri` (for example `http://purl.obolibrary.org/obo/CL_0000236`)

Use in this URL to get more info about the entity

```
https://www.ebi.ac.uk/ols/api/ontologies/cl/terms?iri=http://purl.obolibrary.org/obo/CL_0000236
```

From that response, get a link to its ancestor page in `._embedded.terms[0]._links.hierarchicalAncestors`

```
https://www.ebi.ac.uk/ols/api/ontologies/cl/terms/http%253A%252F%252Fpurl.obolibrary.org%252Fobo%252FCL_0000236/hierarchicalAncestors
```

Traverse the list of ancestors until the root cell `CL_0000000` ancestor is reached. (for B cell this is `._embedded.terms[6]`)