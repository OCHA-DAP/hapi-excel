// Function to load the HAPI openapi definition and list the endpoints with their summaries
let
    Source = Json.Document(Web.Contents("https://hapi.humdata.org/openapi.json")),
    paths = Source[paths],
    endpoints = Record.ToTable(paths),
    record_columns = Table.ExpandRecordColumn(endpoints, "Value", {"get"}, {"Value.get"}),
    summary = Table.ExpandRecordColumn(record_columns, "Value.get", {"summary", "description"})
in
    summary