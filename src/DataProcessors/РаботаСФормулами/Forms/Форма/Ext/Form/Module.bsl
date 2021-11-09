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
	
	ЭтоСпособФормула	= (Объект.СпособРасчета = ПредопределенноеЗначение("Перечисление.СпособыРасчетаПоказателяФормулы.Формула"));
	ЭтоСпособРучнойВвод	= (Объект.СпособРасчета = ПредопределенноеЗначение("Перечисление.СпособыРасчетаПоказателяФормулы.РучнойВвод"));
	ЭтоСпособПустоеЗнач	= (Объект.СпособРасчета = ПредопределенноеЗначение("Перечисление.СпособыРасчетаПоказателяФормулы.ПустаяСсылка"));

	#Область Наборы
	
	Если ИмяРеквизита = "РеквизитыПоказателя" ИЛИ ПустаяСтрока(ИмяРеквизита) Тогда
		УстановитьУсловноеОформлениеРеквизита(Форма, Обработано, "ИмяПоказателя");
		УстановитьУсловноеОформлениеРеквизита(Форма, Обработано, "ОписаниеПоказателя");
	КонецЕсли;

	Если ИмяРеквизита = "РеквизитыСпособРасчета" ИЛИ ПустаяСтрока(ИмяРеквизита) Тогда
		УстановитьУсловноеОформлениеРеквизита(Форма, Обработано, "РеквизитыПоказателя");
		
		УстановитьУсловноеОформлениеРеквизита(Форма, Обработано, "Формула");
		УстановитьУсловноеОформлениеРеквизита(Форма, Обработано, "НеОкруглять");
		УстановитьУсловноеОформлениеРеквизита(Форма, Обработано, "НеОтрицательное");
		УстановитьУсловноеОформлениеРеквизита(Форма, Обработано, "ТочностьОкругления");
		УстановитьУсловноеОформлениеРеквизита(Форма, Обработано, "РучноеЗначение");
		УстановитьУсловноеОформлениеРеквизита(Форма, Обработано, "ЭтоПоказатель");
		УстановитьУсловноеОформлениеРеквизита(Форма, Обработано, "Показатель");
	КонецЕсли;
	
	#КонецОбласти
	
	#Область Элементы
	
	Если ИмяРеквизита = "Формула" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"Формула", "Видимость", ЭтоСпособФормула);
	КонецЕсли;

	Если ИмяРеквизита = "НеОкруглять" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"НеОкруглять", "Видимость", ЭтоСпособФормула);
	КонецЕсли;

	Если ИмяРеквизита = "НеОтрицательное" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"НеОтрицательное", "Видимость", ЭтоСпособФормула);
	КонецЕсли;

	Если ИмяРеквизита = "РучноеЗначение" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"РучноеЗначение", "ТолькоПросмотр", НЕ ЭтоСпособРучнойВвод);
	КонецЕсли;

	Если ИмяРеквизита = "ЭтоПоказатель" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ЭтоПоказатель", "ТолькоПросмотр", ЭтоСпособПустоеЗнач);
	КонецЕсли;

	Если ИмяРеквизита = "Показатель" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"Показатель", "ТолькоПросмотр", ЭтоСпособПустоеЗнач);
	КонецЕсли;

	Если ИмяРеквизита = "ИмяПоказателя" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ИмяПоказателя", "ТолькоПросмотр", НЕ Объект.ЭтоПоказатель ИЛИ Форма.ЗапретитьИзменениеИмени ИЛИ ЭтоСпособПустоеЗнач);
	КонецЕсли;

	Если ИмяРеквизита = "ОписаниеПоказателя" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ОписаниеПоказателя", "ТолькоПросмотр", НЕ Объект.ЭтоПоказатель ИЛИ ЭтоСпособПустоеЗнач);
	КонецЕсли;

	Если ИмяРеквизита = "ТочностьОкругления" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ТочностьОкругления", "ТолькоПросмотр", ЭтоСпособФормула И Объект.НеОкруглять);
	КонецЕсли;

	#КонецОбласти 
	
	#Область Команды
	
	Если ИмяРеквизита = "КомандаЗаписатьИЗакрыть" ИЛИ ПустаяСтрока(ИмяРеквизита) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ФормаЗаписатьИЗакрыть", "Видимость", НЕ Форма.ТолькоПросмотр);
	КонецЕсли;
	
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
		МассивИмен = ОбщегоНазначенияПТБКлиентСервер.СкопироватьРекурсивно(ИменаРеквизитов);
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
Процедура СпособРасчетаПриИзменении(Элемент)
	Если НЕ Объект.СпособРасчета = ПредопределенноеЗначение("Перечисление.СпособыРасчетаПоказателяФормулы.Формула") Тогда
		Объект.Формула			= "";
		Объект.НеОкруглять		= Ложь;
		Объект.НеОтрицательное	= Ложь;
	КонецЕсли;
	
	Если НЕ Объект.СпособРасчета = ПредопределенноеЗначение("Перечисление.СпособыРасчетаПоказателяФормулы.РучнойВвод") Тогда
		Объект.РучноеЗначение = 0;
	КонецЕсли;
	
	УстановитьУсловноеОформление(ЭтотОбъект, "РеквизитыСпособРасчета");
КонецПроцедуры

&НаКлиенте
Процедура ЭтоПоказательПриИзменении(Элемент)
	УстановитьУсловноеОформление(ЭтотОбъект, "РеквизитыПоказателя")
КонецПроцедуры

&НаКлиенте
Процедура ИмяПоказателяПриИзменении(Элемент)
	Если ПустаяСтрока(Объект.ИмяПоказателя) Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ИмяПоказателя = СокрЛП(Объект.ИмяПоказателя);
	
	ИменаПеременных = ПолучитьМассивИменПоказателей(ЭтотОбъект.ДеревоПеременных);
	РезультатПроверки = РаботаСФормуламиКлиентСервер.ПроверитьИмяПоказателя(Объект.ИмяПоказателя, ИменаПеременных);
	Если РезультатПроверки.ЕстьОшибки Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(РезультатПроверки.ТекстСообщения,, "Формула", "Объект");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НеОкруглятьПриИзменении(Элемент)
	УстановитьУсловноеОформление(ЭтотОбъект, "ТочностьОкругления")
КонецПроцедуры

&НаКлиенте
Процедура ФормулаПриИзменении(Элемент)
	Результат = РаботаСФормуламиКлиентСервер.ПроверитьНаличиеОшибокФормулы(Объект.Формула);
	Если Результат.ЕстьОшибки = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.ТекстСообщения,, "Формула", "Объект");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ДеревоПеременных

&НаКлиенте
Процедура ДеревоПеременныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекущиеДанные = Элементы.ДеревоПеременных.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьПеременнуюВФормулу(ТекущиеДанные);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ДеревоФункций

&НаКлиенте
Процедура ДеревоФункцийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекущиеДанные = Элементы.ДеревоФункций.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьФункциюВФормулу(ТекущиеДанные);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ТипЗнч(Параметры.ТекущаяФормула) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект.Объект, Параметры.ТекущаяФормула);
	КонецЕсли;
	Если ТипЗнч(Параметры.Формулы) = Тип("Массив") Тогда
		Для Каждого СтруктураСтроки Из Параметры.Формулы Цикл
			НоваяСтрока = Объект.ФормулыРасчета.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураСтроки);
		КонецЦикла;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Идентификатор) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Неверно переданы параметры.'"),, "Объект.Идентификатор",, Отказ);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// удалим возможность выбора пустого значения
	Если НЕ Параметры.РазрешитьПустоеЗначение Тогда
		СписокВыбора = Элементы.СпособРасчета.СписокВыбора;
		ЭлементУдалить = СписокВыбора.НайтиПоЗначению(ПредопределенноеЗначение("Перечисление.СпособыРасчетаПоказателяФормулы.ПустаяСсылка"));
		Если ЭлементУдалить <> Неопределено Тогда
			СписокВыбора.Удалить(ЭлементУдалить);
		КонецЕсли;
	КонецЕсли;
	
	ЭтотОбъект.ЗапретитьИзменениеИмени = ЗначениеЗаполнено(Объект.ИмяПоказателя);
	
	ЗаполнитьДеревоОператоровНаСервере();
	ЗаполнитьДеревоПоказателямиНаСервере(Параметры.Показатели);
	ЗаполнитьДеревоПеременныхНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьУсловноеОформление(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЭтотОбъект.Модифицированность И НЕ ЗавершениеРаботы Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru='Данные были изменены. Выполнить сохранение?'"), РежимДиалогаВопрос.ДаНетОтмена, 60);
		Отказ = Истина; 
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// получить все имена переменных
	ИменаПеременных = ПолучитьМассивИменПоказателей(ЭтотОбъект.ДеревоПеременных);
	
	// проверка имени показателя
	Если ЭтотОбъект.ЗапретитьИзменениеИмени = Ложь И Объект.ЭтоПоказатель Тогда
		РезультатПроверки = РаботаСФормуламиКлиентСервер.ПроверитьИмяПоказателя(Объект.ИмяПоказателя, ИменаПеременных, Отказ);
		Если РезультатПроверки.ЕстьОшибки Тогда
			ОбщегоНазначения.СообщитьПользователю(РезультатПроверки.ТекстСообщения,, "Формула", "Объект", Отказ);
		КонецЕсли;
	КонецЕсли;
	
	// проверим все показатели формулы
	Если НЕ Отказ И НЕ ПустаяСтрока(Объект.Формула) Тогда
		ВсеПоказатели = РаботаСФормуламиКлиентСервер.ПолучитьВсеПоказателиФормулы(Объект.Формула);
		
		СписокОшибок = Новый Массив;
		Для Каждого Имя Из ВсеПоказатели Цикл
			СтрокаПоказателя = ИменаПеременных.Получить(Имя);
			Если СтрокаПоказателя = Неопределено Тогда
				СписокОшибок.Добавить(ВРег(Имя));
			КонецЕсли;
		КонецЦикла;
		
		Если СписокОшибок.Количество() > 0 Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Переменные ""%1"" формулы не найдены в дереве переменных.'"),
				СтрСоединить(СписокОшибок, "; "));
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Формула", "Объект", Отказ);
		КонецЕсли;
	КонецЕсли;
	
	// проверка использования ","
	Если НЕ Отказ И НЕ ПустаяСтрока(Объект.Формула) Тогда
		РезультатПроверки = РаботаСФормуламиКлиентСервер.ПроверитьНаличиеОшибокФормулы(Объект.Формула);
		Если РезультатПроверки.ЕстьОшибки Тогда
			ОбщегоНазначения.СообщитьПользователю(РезультатПроверки.ТекстСообщения,, "Формула", "Объект", Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьПеременную(Команда)
	ДобавитьПеременнуюВФормулу();
КонецПроцедуры
 
&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	Если ЭтотОбъект.Модифицированность Тогда
		Результат = ЭтотОбъект.ПроверитьЗаполнение();
		Если НЕ Результат Тогда
			Возврат;
		КонецЕсли;
		
		ЭтотОбъект.Модифицированность = Ложь;
		ЭтотОбъект.Закрыть(ПолучитьДанныеФормы());
	Иначе 
		ЭтотОбъект.Закрыть(Неопределено);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ЗавершениеНемодальныхВызовов

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ПараметрыВыполнения) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		ЭтотОбъект.Модифицированность = Ложь;
		ЭтотОбъект.Закрыть(Неопределено);
	Иначе
		ЭтотОбъект.Модифицированность = Ложь;
		ЭтотОбъект.Закрыть(ПолучитьДанныеФормы());
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте 
Процедура ДобавитьПеременнуюВФормулу(знач ТекущиеДанные = Неопределено)
	Если ТекущиеДанные = Неопределено Тогда
		ТекущиеДанные = Элементы.ДеревоПеременных.ТекущиеДанные;
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.ТолькоПросмотр Тогда
		Возврат;
	ИначеЕсли ТекущиеДанные.ЭтоГруппа Тогда
		Возврат;
	ИначеЕсли ТекущиеДанные.ТипПеременной <= 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Объект.СпособРасчета = ПредопределенноеЗначение("Перечисление.СпособыРасчетаПоказателяФормулы.Формула") Тогда
		Возврат;
	КонецЕсли;
	
	Объект.Формула = СокрЛП(Объект.Формула) + ТекущиеДанные.Показатель;
	
	ЭтотОбъект.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте 
Процедура ДобавитьФункциюВФормулу(знач ТекущиеДанные = Неопределено)
	Если ТекущиеДанные = Неопределено Тогда
		ТекущиеДанные = Элементы.ДеревоФункций.ТекущиеДанные;
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.ТолькоПросмотр Тогда
		Возврат;
	ИначеЕсли ТекущиеДанные.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Объект.СпособРасчета = ПредопределенноеЗначение("Перечисление.СпособыРасчетаПоказателяФормулы.Формула") Тогда
		Возврат;
	КонецЕсли;
	
	ЗначениеПодстановки = ТекущиеДанные.Подстановка;
	Если НЕ ЗначениеЗаполнено(Объект.Формула) Тогда
		ЗначениеПодстановки = СокрЛ(ЗначениеПодстановки);
	КонецЕсли;
	
	Объект.Формула = СокрЛП(Объект.Формула) + ЗначениеПодстановки;
	
	ЭтотОбъект.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте 
Функция ПолучитьДанныеФормы()
	СтруктураДанных = РаботаСФормуламиКлиентСервер.СтруктураФормулы();
	ЗаполнитьЗначенияСвойств(СтруктураДанных, Объект);
	Возврат СтруктураДанных;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьСтрокуПоказателя(знач Значение, знач ТаблицаДанных)
	СтрокаПоказателя = Неопределено;
	
	СтруктураОтбора = Новый Структура("НРегПоказатель", НРег(Значение));
	СтрокиДанных = ТаблицаДанных.НайтиСтроки(СтруктураОтбора);
	Если СтрокиДанных.Количество() <> 0 Тогда
		СтрокаПоказателя = СтрокиДанных[0];
	КонецЕсли;
	
	Возврат СтрокаПоказателя;
КонецФункции

&НаКлиентеНаСервереБезКонтекста 
Функция ПолучитьМассивИменПоказателей(знач ДеревоЗначений, знач ДанныеДополнения = Неопределено)
	Если НЕ ТипЗнч(ДанныеДополнения) = Тип("Соответствие") Тогда
		ДанныеДополнения = Новый Соответствие;
	КонецЕсли;
	
	Для Каждого СтрокаДерева Из ДеревоЗначений.ПолучитьЭлементы() Цикл
		Если СтрокаДерева.ЭтоГруппа ИЛИ СтрокаДерева.ТипПеременной <= 0 Тогда
			ПолучитьМассивИменПоказателей(СтрокаДерева, ДанныеДополнения);
		Иначе
			ДанныеДополнения.Вставить(НРег(СтрокаДерева.Показатель),
				Новый Структура("Показатель, Описание",
					СтрокаДерева.Показатель,
					СтрокаДерева.Описание));
		КонецЕсли;
	КонецЦикла;
	
	Возврат ДанныеДополнения;
КонецФункции

&НаКлиентеНаСервереБезКонтекста 
Функция ЭтоСтруктураГруппыПоказателей(знач Структура)
	Возврат ТипЗнч(Структура) = Тип("Структура")
		И Структура.Свойство("Тип")
		И Структура.Тип = "Группа";
КонецФункции

&НаКлиентеНаСервереБезКонтекста 
Функция ЭтоСтруктураЭлементаПоказателей(знач Структура)
	Возврат ТипЗнч(Структура) = Тип("Структура")
		И Структура.Свойство("Тип")
		И Структура.Тип = "Показатель";
КонецФункции

&НаСервере 
Процедура ЗаполнитьДеревоПоказателямиНаСервере(знач Показатели)
	Если НЕ ТипЗнч(Показатели) = Тип("Структура") Тогда
		Возврат;
	КонецЕсли;

	Для Каждого КлючИЗначениеГруппы Из Показатели Цикл
		ИмяГруппы			= КлючИЗначениеГруппы.Ключ;
		ГруппаПоказателей	= КлючИЗначениеГруппы.Значение;
		
		Если НЕ ЭтоСтруктураГруппыПоказателей(ГруппаПоказателей) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаГруппы = ЭтотОбъект.ДеревоПеременных.ПолучитьЭлементы().Добавить();
		СтрокаГруппы.ИндексКартинки	= 0;
		СтрокаГруппы.ТипПеременной	= 0;
		СтрокаГруппы.Показатель		= ИмяГруппы;
		СтрокаГруппы.ЭтоГруппа		= Истина;
		СтрокаГруппы.Описание		= ГруппаПоказателей.Описание; 
		
		Для Каждого КлючИЗначениеЭлемента Из ГруппаПоказателей.Элементы Цикл
			ИмяПоказателя		= КлючИЗначениеЭлемента.Ключ;
			ЭлементПоказателя	= КлючИЗначениеЭлемента.Значение;
			
			Если НЕ ЭтоСтруктураЭлементаПоказателей(ЭлементПоказателя) Тогда
				Продолжить;
			КонецЕсли;
			
			СтрокаДерева = СтрокаГруппы.ПолучитьЭлементы().Добавить();
			СтрокаДерева.ИндексКартинки	= 3;
			СтрокаДерева.ТипПеременной	= 1;
			СтрокаДерева.Показатель		= ЭлементПоказателя.Показатель;
			СтрокаДерева.Описание		= ЭлементПоказателя.Описание;
			СтрокаДерева.НРегПоказатель	= НРег(ЭлементПоказателя.Показатель);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаСервере 
Процедура ЗаполнитьДеревоОператоровНаСервере()
	МассивСтрок = Новый Массив;
	
	МассивСтрок.Добавить(Новый Структура("Описание,Операторы",
		НСтр("ru='Арифметические операторы'"),
		РаботаСФормуламиКлиентСервер.АрифметическиеОператоры()));
	
	МассивСтрок.Добавить(Новый Структура("Описание,Операторы",
		НСтр("ru='Логические операторы'"),
		РаботаСФормуламиКлиентСервер.ЛогическиеОператоры()));
	
	МассивСтрок.Добавить(Новый Структура("Описание,Операторы",
		НСтр("ru='Математические функции'"),
		РаботаСФормуламиКлиентСервер.МатематическиеОператоры()));
	
	МассивСтрок.Добавить(Новый Структура("Описание,Операторы",
		НСтр("ru='Строковые операторы'"),
		РаботаСФормуламиКлиентСервер.СтроковыеОператоры()));

	Для Индекс = 0 По МассивСтрок.ВГраница() Цикл
		СтруктураЗаписи = МассивСтрок[Индекс];
		
		СтрокаГруппа = ЭтотОбъект.ДеревоФункций.ПолучитьЭлементы().Добавить();
		СтрокаГруппа.ИндексКартинки	= 0;
		СтрокаГруппа.ЭтоГруппа		= Истина;
		СтрокаГруппа.Описание		= СтруктураЗаписи.Описание; 
	
		Для Каждого СтруктураОператора Из СтруктураЗаписи.Операторы Цикл
			СтрокаДерева = СтрокаГруппа.ПолучитьЭлементы().Добавить();
			СтрокаДерева.ИндексКартинки	= 3;
			ЗаполнитьЗначенияСвойств(СтрокаДерева, СтруктураОператора);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаСервере 
Процедура ЗаполнитьДеревоПеременныхНаСервере()
	// строка дерева "Переменные из формул"
	СтрокаПеременные = ЭтотОбъект.ДеревоПеременных.ПолучитьЭлементы().Добавить();
	СтрокаПеременные.ИндексКартинки	= 0;
	СтрокаПеременные.ТипПеременной	= 0;
	СтрокаПеременные.Показатель		= НСтр("ru='Группа_Переменные'");
	СтрокаПеременные.ЭтоГруппа		= Истина;
	СтрокаПеременные.Описание		= НСтр("ru='Переменные из формул'"); 
	
	СтруктураОтбора = Новый Структура("ЭтоПоказатель", Истина);
	МассивСтрок = Объект.ФормулыРасчета.НайтиСтроки(СтруктураОтбора);
	Для Каждого СтрокаПоказателя Из МассивСтрок Цикл
		Если СтрокаПоказателя.Идентификатор = Объект.Идентификатор Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаДерева = СтрокаПеременные.ПолучитьЭлементы().Добавить();
		СтрокаДерева.ИндексКартинки	= 3;
		СтрокаДерева.ТипПеременной	= 1;
		СтрокаДерева.Показатель		= СтрокаПоказателя.ИмяПоказателя;
		СтрокаДерева.Описание		= СтрокаПоказателя.ОписаниеПоказателя;
		СтрокаДерева.НРегПоказатель	= НРег(СтрокаДерева.Показатель);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
