require "graphlient"

client = Graphlient::Client.new('https://test-graphql.biz/graphql',
  headers: {
    'Authorization' => 'Bearer 123'
  },
  http_options: {
    read_timeout: 20,
    write_timeout: 30
  }
)

# simple query
response = client.query <<~GRAPHQL
  query {
    invoice(id: 10) {
      id
      total
      line_items {
        price
        item_type
      }
    }
  }
GRAPHQL

response = client.query do
  # steep:ignore:start
  query do
    invoice(id: 10) do
      id
      total
      line_items do
        price
        item_type
      end
    end
  end
  # steep:ignore:end
end

# Executing Parameterized Queries and Mutations
query = <<-GRAPHQL
  query($ids: [Int]) {
    invoices(ids: $ids) {
      id
      fee_in_cents
    }
  }
GRAPHQL
variables = { ids: [42] }

client.query(query, variables)

client.query(ids: [42]) do
  # steep:ignore:start
  query(ids: [:int]) do
    invoices(ids: :ids) do
      id
      fee_in_cents
    end
  end
  # steep:ignore:end
end
