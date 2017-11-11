defmodule PlateSlateWeb.Schema.Query.MenuItemsTest do
  use PlateSlateWeb.ConnCase, async: true

  setup do
    Code.load_file("priv/repo/seeds.exs")
  end

  @query """
  {
    menuItems {
      name
    }
  }
  """
  test "menuItems field returns menu items" do
    conn = build_conn()
    conn = get conn, "/api", query: @query
    assert json_response(conn, 200) == %{
      "data" => %{
        "menuItems" => [
          %{"name" => "Rueben"},
          %{"name" => "Croque Monsieur"},
          %{"name" => "Muffuletta"},
          %{"name" => "Bánh mì"},
          %{"name" => "Vada Pav"},
          %{"name" => "French Fries"},
          %{"name" => "Papadum"},
          %{"name" => "Pasta Salad"},
          %{"name" => "Water"},
          %{"name" => "Soft Drink"},
          %{"name" => "Lemonade"},
          %{"name" => "Masala Chai"},
          %{"name" => "Vanilla Milkshake"},
          %{"name" => "Chocolate Milkshake"}
        ]
      }
    }
  end

  @query """
  query($term: String) {
    menuItems(matching: $term) {
      name
    }
  }
  """
  @variables %{"term" => "rue"}
  test "menuItems field returns menu items filtered by name" do
    conn = get(build_conn(), "/api", query: @query, variables: @variables)
    assert json_response(conn, 200) == %{
      "data" => %{
        "menuItems" => [
          %{"name" => "Rueben"},
        ]
      }
    }
  end

  @query """
  {
    menuItems(matching: 123) {
      name
    }
  }
  """
  test "menuItems field returns errors when using a bad value" do
    response = get(build_conn(), "/api", query: @query)
    assert %{"errors" => [
      %{"message" => message}
    ]} = json_response(response, 400)
    assert message == "Argument \"matching\" has invalid value 123."
  end
end
