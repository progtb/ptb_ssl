﻿
#Область УправлениеФормой

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьУсловноеОформлениеРеквизита(Форма, Обработано, ИмяРеквизита)

	Если НЕ Обработано.Найти(ИмяРеквизита) = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Обработано.Добавить(ИмяРеквизита);

	Элементы	= Форма.Элементы;
	Объект		= Форма.Объект;

	#Область Наборы
	
	//Если ИмяРеквизита = "Реквизиты" ИЛИ ПустаяСтрока(ИмяРеквизита) Тогда
	//	УстановитьУсловноеОформлениеРеквизита(Форма, Обработано, "");
	//	УстановитьУсловноеОформлениеРеквизита(Форма, Обработано, "");
	//КонецЕсли;

	#КонецОбласти
	
	#Область Элементы
	
	Если ИмяРеквизита = "ПользовательАвторизации" ИЛИ ПустаяСтрока(ИмяРеквизита) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ПользовательАвторизации", "Видимость", Объект.ЕдинаяАвторизация);
	КонецЕсли;

	#КонецОбласти 
	
	#Область ТабЧасть_Имя
	
	//Если ИмяРеквизита = "ИмяТабличнойЧастиОтветственный" ИЛИ ПустаяСтрока(ИмяРеквизита) Тогда
	//	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
	//		"ИмяТабличнойЧастиОтветственный", "ТолькоПросмотр", ЗначениеЗаполнено(Объект.Ответственный));
	//КонецЕсли;

	#КонецОбласти
	
	#Область Команды
	
	//Если ИмяРеквизита = "КомандаЗаполнить" ИЛИ ПустаяСтрока(ИмяРеквизита) Тогда
	//	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
	//		"ТаблицаФормыЗаполнить", "Видимость", НЕ Объект.Проведен);
	//КонецЕсли;

	#КонецОбласти 
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьУсловноеОформление(Форма, ИменаРеквизитов = "")

	Если ТипЗнч(ИменаРеквизитов) = Тип("Строка") Тогда
		Если ПустаяСтрока(ИменаРеквизитов) Тогда
			МассивИмен = Новый Массив;
			МассивИмен.Добавить("");
		Иначе
			МассивИмен = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаРеквизитов, ",");
		КонецЕсли;
	ИначеЕсли ТипЗнч(ИменаРеквизитов) = Тип("Массив") Тогда
		МассивИмен = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(ИменаРеквизитов);
	Иначе
		Возврат;
	КонецЕсли;
 
	//Форма.ТолькоПросмотр = (Форма.СостоянияЗаблокировано.Найти(Форма.СведенияОЗаявкеСостояние) <> Неопределено);

	Обработано = Новый Массив;
	Для Каждого ИмяРеквизита Из МассивИмен Цикл
		УстановитьУсловноеОформлениеРеквизита(Форма, Обработано, СокрЛП(ИмяРеквизита));
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЕдинаяАвторизацияПриИзменении(Элемент)
	
	УстановитьУсловноеОформление(ЭтотОбъект, "ПользовательАвторизации");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьУсловноеОформление(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

