# If necessary, uncomment the line below to include explore_source.
# include: "mock_codec.model.lkml"

view: order_facts {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: created_date {}
      column: user_id {}
      column: total_sales {}
      derived_column: order_sequence {
        sql: RANK () OVER (PARTITION BY user_id ORDER BY created_date) ;;
      }
    }
  }
  dimension: order_id {
    label: "(1) Orders Order ID"
    type: number
  }
  dimension: created_date {
    label: "(1) Orders Created Date"
    type: date
  }
  dimension: user_id {
    label: "(1) Orders User ID"
    type: number
  }
  dimension: total_sales {
    label: "(1) Orders Total Sales"
    value_format: "$#,##0.00"
    type: number
  }
  dimension: order_sequence {
    type: number
    label: "Order Sequence by user"
  }
}
