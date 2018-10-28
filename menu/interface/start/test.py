from consolemenu import *
from consolemenu.items import *
from consolemenu.format import *
from consolemenu.menu_component import Dimension

#
# Example 4 shows the use of menu border styles and borders on items.
#


def main():

    # Menu Format
    thin = Dimension(width=40, height=40)  # Use a Dimension to limit the "screen width" to 40 characters

    menu_format = MenuFormatBuilder(max_dimension=thin)

    # Set the border style to use heavy outer borders and light inner borders
    menu_format.set_border_style_type(MenuBorderStyleType.DOUBLE_LINE_OUTER_LIGHT_INNER_BORDER)

    menu_format.set_title_align('center')                   # Center the menu title (by default it's left-aligned)
    menu_format.set_prologue_text_align('center')           # Center the prologue text (by default it's left-aligned)
    menu_format.show_prologue_bottom_border(True)           # Show a border under the prologue

    # Create the root menu
    menu = ConsoleMenu("Menu With Item Borders",
                       prologue_text=("This menu example shows how menu items can be separated into categories."))
    menu.formatter = menu_format

    # Create some menu items
    menu_item_1 = MenuItem("Menu Item 1")
    menu_item_2 = MenuItem("Menu Item 2")
    menu_item_3 = MenuItem("Menu Item 3")
    menu_item_4 = MenuItem("Menu Item 4")
    menu_item_5 = MenuItem("Menu Item 5")
    menu_item_6 = MenuItem("Menu Item 6")
    menu_item_7 = MenuItem("Menu Item 7")
    menu_item_8 = MenuItem("Menu Item 8")

    menu_format.show_item_top_border(menu_item_2.text, True)     # Show a border above item 2
    menu_format.show_item_top_border(menu_item_4.text, True)     # Show a border above item 4
    menu_format.show_item_bottom_border(menu_item_5.text, True)  # Show a border *below* item 4

    # To separate the exit item from other menu items, you can either put a bottom border on the
    # last item you added to the menu (menu_item_8 in this example), or, you can put a top
    # border on the exit_item.text property of the menu instance.
    menu_format.show_item_top_border(menu.exit_item.text, True)

    # Add menu items to menu
    menu.append_item(menu_item_1)
    menu.append_item(menu_item_2)
    menu.append_item(menu_item_3)
    menu.append_item(menu_item_4)
    menu.append_item(menu_item_5)
    menu.append_item(menu_item_6)
    menu.append_item(menu_item_7)
    menu.append_item(menu_item_8)

    # Show the menu
    menu.show(True)


if __name__ == "__main__":
    main()
