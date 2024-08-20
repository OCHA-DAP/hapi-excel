// Power Query Function to download data from a HAPI endpoint, paging through available results to the end
let
    hapi_base_url = "https://hapi.humdata.org/api/v1/metadata/admin2?output_format=csv&app_identifier=#[token]&limit=1000&offset=#[offset]",
    token = "", //App identifier obtained from https://hapi.humdata.org/docs#/Generate%20App%20Identifier/get_encoded_identifier_api_v1_encode_app_identifier_get
    offset = 0,
    query_url = Text.Format(hapi_base_url, [token=token, offset=offset]),
    source = List.Generate(
    () => [offset = 0, contents=Csv.Document(Web.Contents(query_url),[Delimiter=",", Columns=12, Encoding=65001, QuoteStyle=QuoteStyle.None])],
    // each [offset] < 10000,
    each Table.RowCount([contents]) <> 0,
    each [offset = [offset] + 1000, query_url = Text.Format(hapi_base_url, [token=token, offset=offset]), contents=Csv.Document(Web.Contents(query_url),[Delimiter=",", Columns=12, Encoding=65001, QuoteStyle=QuoteStyle.None])],
    each if [offset] > 0 then Table.Skip([contents]) else [contents]),
    CombinedTable = Table.PromoteHeaders(Table.Combine(source))
in
    CombinedTable
    // https://hapi.humdata.org/api/v1/metadata/admin2?output_format=json&app_identifier=SERYSU5URVJOQUxfZXhjZWxfaWg6aWFuLmhvcGtpbnNvbkBodW1kYXRhLm9yZw%3D%3D&limit=1000&offset=0