"""Ваши проверки. Сначала рассчитайте ожидания по требованиям, затем пишите код."""

import unittest
from copy import deepcopy
from mediapolka import new_state, issue, return_loan

class TestMediaPolka(unittest.TestCase):

    # R2: Проверка пробелов по краям
    def test_issue_with_spaces(self):
        state = new_state()
        # Пытаемся выдать 2 микрофона, но с пробелами в строке
        res = issue(state, "mic", " 2 ")
        
        # Ожидаем, что программа поймет количество и выдаст
        self.assertTrue(res["ok"], f"Ожидался успех, но получено: {res}")
        self.assertEqual(state["stock"]["mic"], 1, "Остаток не уменьшился правильно")
        self.assertEqual(len(state["loans"]), 1, "Выдача не создалась")

    # R2: Проверка нулевого количества (граница)
    def test_issue_zero_quantity(self):
        state = new_state()
        before = deepcopy(state)
        
        # Пытаемся выдать 0 микрофонов
        res = issue(state, "mic", "0")
        
        # Ожидаем отказ и отсутствие изменений
        self.assertFalse(res["ok"], "Нулевое количество не было отклонено")
        self.assertEqual(res["message"], "Введите целое количество от 1 до 3")
        self.assertEqual(state, before, "Состояние изменилось при отказе")

    # R3: Проверка нехватки оборудования (света 0, пытаемся выдать 1)
    def test_issue_insufficient_stock(self):
        state = new_state()
        before = deepcopy(state)
        
        res = issue(state, "light", "1")
        
        # Ожидаем отказ и отсутствие изменений
        self.assertFalse(res["ok"], "Нехватка остатка не была обработана")
        self.assertEqual(res["message"], "Недостаточно оборудования")
        self.assertEqual(state, before, "Состояние изменилось при отказе")
        self.assertEqual(state["next_id"], 1, "ID израсходовался при отказе")

    # R4: Проверка инкремента ID
    def test_issue_increments_id(self):
        state = new_state()
        
        # Выдаем 1 микрофон
        res1 = issue(state, "mic", "1")
        self.assertTrue(res1["ok"])
        self.assertEqual(res1["loan_id"], 1)
        
        # Выдаем еще 1 микрофон
        res2 = issue(state, "mic", "1")
        self.assertTrue(res2["ok"])
        self.assertEqual(res2["loan_id"], 2, "ID не увеличился на 1")
        
        # Отказ не должен расходовать ID
        issue(state, "light", "1") # Это должно упасть по R3
        
        # Снова выдаем
        res3 = issue(state, "mic", "1")
        self.assertTrue(res3["ok"])
        self.assertEqual(res3["loan_id"], 3, "ID израсходовался при отказе")

    # R5 и R6: Возврат и повторный возврат
    def test_return_success_and_twice(self):
        state = new_state()
        
        # Выдаем 2 микрофона (ID 1)
        issue(state, "mic", "2")
        self.assertEqual(state["stock"]["mic"], 1)
        
        # Возвращаем (успешный возврат)
        ret_res = return_loan(state, 1)
        self.assertTrue(ret_res["ok"])
        self.assertEqual(ret_res["message"], "Возвращено")
        self.assertEqual(state["stock"]["mic"], 3, "Остаток не вернулся")
        self.assertEqual(state["loans"][0]["status"], "returned", "Статус не изменился")
        
        # Пытаемся вернуть второй раз (R6)
        before = deepcopy(state)
        ret_res2 = return_loan(state, 1)
        
        self.assertFalse(ret_res2["ok"], "Повторный возврат не был заблокирован")
        self.assertEqual(ret_res2["message"], "Уже возвращено")
        self.assertEqual(state, before, "Состояние изменилось при повторном возврате")
