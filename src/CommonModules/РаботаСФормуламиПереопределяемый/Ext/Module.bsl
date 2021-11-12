﻿
#Область ПрограммныйИнтерфейс

// Вызывается перед заполнением показателей в форму редактирования формулы
//
// Параметры:
//	Форма		- ФормаКлиентскогоПриложения
//	Показатели	- Структура - см. РаботаСФормуламиКлиентСервер.ДобавитьГруппуПоказателей
//
Процедура ПередЗаполнениемПоказателей(Форма, Показатели) Экспорт
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполненияНаСервере(Форма, Отказ, ПроверяемыеРеквизиты) Экспорт
КонецПроцедуры

#КонецОбласти
