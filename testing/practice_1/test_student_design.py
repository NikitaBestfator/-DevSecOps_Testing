import pytest
from gilded_rose import Item, GildedRose


def test_ordinary_item_before_sell_date():
    """T01: Обычный товар теряет 1 качество до срока."""
    items = [Item("ordinary", 5, 10)]
    gilded_rose = GildedRose(items)
    gilded_rose.update_quality()

    assert items[0].sell_in == 4
    assert items[0].quality == 9


def test_ordinary_item_after_sell_date():
    """T02: Обычный товар теряет 2 качества после срока."""
    items = [Item("ordinary", 0, 10)]
    gilded_rose = GildedRose(items)
    gilded_rose.update_quality()

    assert items[0].sell_in == -1
    assert items[0].quality == 8


def test_conjured_before_sell_date():
    """T10: Conjured теряет 2 качества до срока."""
    items = [Item("Conjured Mana Cake", 5, 10)]
    gilded_rose = GildedRose(items)
    gilded_rose.update_quality()

    assert items[0].sell_in == 4
    assert items[0].quality == 8


def test_backstage_pass_threshold_10():
    """T06: Backstage passes растут на 2 при sell_in <= 10."""
    items = [Item("Backstage passes to a TAFKAL80ETC concert", 11, 20)]
    gilded_rose = GildedRose(items)
    gilded_rose.update_quality()

    assert items[0].sell_in == 10
    assert items[0].quality == 22

"""Усложнение"""
@pytest.mark.parametrize("sell_in, expected_quality", [
    (11, 21),  # до порога 10: +1
    (10, 22),  # порог 10: +2 (упадёт — дефект)
    (6, 22),   # между 10 и 5: +2
    (5, 23),   # порог 5: +3
    (1, 23),   # после 5: +3
    (0, 0),    # концерт прошёл: 0
])
def test_backstage_passes_thresholds(sell_in, expected_quality):
    items = [Item("Backstage passes to a TAFKAL80ETC concert", sell_in, 20)]
    gilded_rose = GildedRose(items)
    gilded_rose.update_quality()
    assert items[0].quality == expected_quality