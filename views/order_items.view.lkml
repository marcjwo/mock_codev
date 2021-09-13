view: order_items {
  sql_table_name: `thelook.order_items`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
    value_format_name: usd
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- User added dimensions and measures

  dimension: item_margin {
    type: number
    sql: ${sale_price}-${inventory_items.cost} ;;
    value_format_name: usd
  }

  measure: total_margin {
    type: sum
    sql: ${item_margin} ;;
    value_format_name: usd
  }

  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  dimension: completed_order {
    type: yesno
    sql: ${status} = 'Complete' ;;
  }

  dimension_group: duration_since_sign_up {
    type: duration
    intervals: [day, month, year]
    sql_start: ${users.created_date} ;;
    sql_end: ${created_date} ;;
  }

  measure: distinct_order_count {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: distinct_complete_orders {
    type: count_distinct
    sql: ${order_id} ;;
    filters: [completed_order: "Yes"]
  }

  measure: completed_order_ratio {
    type: number
    sql: ${distinct_complete_orders}/Nullif(${distinct_order_count},0) ;;
    value_format_name: percent_2
  }


  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.last_name,
      users.id,
      users.first_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
