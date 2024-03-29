﻿
#Область ОбработчикиСобытийЭлементовТаблицыФормы_КомпоновщикНастроекНастройкиОтборДоступныеПоляОтбора
 
&НаКлиенте
Процедура КомпоновщикНастроекНастройкиОтборДоступныеПоляОтбораВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыполнитьВыбор(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ТипЗнч(Параметры.КомпоновщикНастроек) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не верно переданы параметры отбора. Попробуйте еще раз или обратитесь к разработчику.'"),,,, Отказ); 
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект.АдресХранилища		= Параметры.АдресХранилища;
	ЭтотОбъект.КомпоновщикНастроек	= Параметры.КомпоновщикНастроек;
	
	Если Параметры.ТекущееПоле <> Неопределено Тогда
		ДоступноеПоле = ЭтотОбъект.КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(Параметры.ТекущееПоле));
		Если ТипЗнч(ДоступноеПоле) = Тип("ДоступноеПолеОтбораКомпоновкиДанных") Тогда 
			Идентификатор = ЭтотОбъект.КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.ПолучитьИдентификаторПоОбъекту(ДоступноеПоле);
			Элементы.КомпоновщикНастроекНастройкиОтборДоступныеПоляОтбора.ТекущаяСтрока = Идентификатор;
		КонецЕсли;
	КонецЕсли;
	
	ОграничитьДоступностьПолейНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьВыбор(Команда)
	
	ТекущаяСтрока = Элементы.КомпоновщикНастроекНастройкиОтборДоступныеПоляОтбора.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДоступноеПолеОтбора = ЭтотОбъект.КомпоновщикНастроек.Настройки.Отбор.ДоступныеПоляОтбора.ПолучитьОбъектПоИдентификатору(ТекущаяСтрока);
	ЭтотОбъект.Закрыть(Строка(ДоступноеПолеОтбора.Поле));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере 
Процедура ОграничитьДоступностьПолейНаСервере()
	
	ПолеОграничения = Элементы.КомпоновщикНастроекНастройкиОтборДоступныеПоляОтбора.ОграниченияИспользования.Добавить();
	ПолеОграничения.Поле		= Новый ПолеКомпоновкиДанных("ПараметрыДанных");
	ПолеОграничения.Доступность	= Ложь;
	
	Если ТипЗнч(Параметры.ЗапрещенныеПоля) = Тип("Массив") Тогда
		Для Каждого ИмяПоля Из Параметры.ЗапрещенныеПоля Цикл
			ПолеОграничения = Элементы.КомпоновщикНастроекНастройкиОтборДоступныеПоляОтбора.ОграниченияИспользования.Добавить();
			ПолеОграничения.Поле		= Новый ПолеКомпоновкиДанных(ИмяПоля);
			ПолеОграничения.Доступность	= Ложь;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


