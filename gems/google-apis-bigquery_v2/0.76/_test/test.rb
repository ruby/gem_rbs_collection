require "google-apis-bigquery_v2"
require "googleauth"

json_key = ''
client = Google::Apis::BigqueryV2::BigqueryService.new
client.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
  json_key_io: StringIO.new(json_key), scope: [Google::Apis::BigqueryV2::AUTH_BIGQUERY]
)
query = 'SELECT 1'
request = Google::Apis::BigqueryV2::QueryRequest.new(query:, use_legacy_sql: false)
client.query_job('this is project_id', request)
