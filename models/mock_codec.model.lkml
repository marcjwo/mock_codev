connection: "thelook_bq"

# include all the views
include: "/views/**/*.view"

datagroup: mock_codec_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: mock_codec_default_datagroup


explore: order_items {
  fields: [ALL_FIELDS*, -order_facts.order_id]
  view_label: "(1) Orders"
  join: users {
    view_label: "(2) User"
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    view_label: "(3) Inventory Item"
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    view_label: "(4) Products"
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    view_label: "(5) Distribution Center"
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  join: order_facts {
    view_label: "(6) Additional Order Facts"
    type: left_outer
    sql_on: ${order_items.order_id} = ${order_facts.order_id} ;;
    relationship: many_to_one
  }
}
