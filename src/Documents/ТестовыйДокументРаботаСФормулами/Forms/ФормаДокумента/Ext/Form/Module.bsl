﻿
#Область ОбработчикиСобытийЭлементовТаблицыФормы_ФормулыРасчета

&НаКлиенте
Процедура ФормулыРасчетаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекущиеДанные = Элементы.ФормулыРасчета.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РучнойВвод = ПредопределенноеЗначение("Перечисление.СпособыРасчетаПоказателяФормулы.РучнойВвод");
	
	ИмяКолонки = СтрЗаменить(Поле.Имя, "ФормулыРасчета", "");
	Если СтрНайти("НомерСтроки, Представление", ИмяКолонки) > 0 Тогда
		Возврат;
	ИначеЕсли ИмяКолонки = "Сумма" И ТекущиеДанные.СпособРасчета = РучнойВвод Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	РедактироватьФормулу(ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ФормулыРасчетаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = Элементы.ФормулыРасчета.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если НоваяСтрока Тогда
		ТекущиеДанные.Идентификатор = "";
		ТекущиеДанные.Колонка		= "Сумма";
	КонецЕсли;                         
	
	Если НЕ ЗначениеЗаполнено(ТекущиеДанные.СпособРасчета) Тогда
		ТекущиеДанные.СпособРасчета = ПредопределенноеЗначение("Перечисление.СпособыРасчетаПоказателяФормулы.Формула");
		ТекущиеДанные.РасчетПредставление = РаботаСФормуламиКлиентСервер.ПолучитьРасчетПредставление(ТекущиеДанные);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТекущиеДанные.Идентификатор) Тогда
		ТекущиеДанные.Идентификатор = Формат(ТекущаяУниверсальнаяДатаВМиллисекундах(), "ЧГ=");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФормулыРасчетаПередУдалением(Элемент, Отказ)
	ТекущиеДанные = Элементы.ФормулыРасчета.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Предопределенный Тогда
		ПоказатьПредупреждение(, НСтр("ru='Данную строку удалить нельзя'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	ПараметрыОповещения	= Новый Структура;
	ПараметрыОповещения.Вставить("Идентификатор", ТекущиеДанные.ПолучитьИдентификатор());
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ФормулыРасчетаПередУдалениемВопросЗавершение", ЭтотОбъект, ПараметрыОповещения);
	
	Если ТекущиеДанные.ЭтоПоказатель Тогда
		ПоказатьВопрос(ОписаниеОповещения,
			НСтр("ru='Данная строка является показателем, который может быть использован в формулах. Продолжить удаление строки?'"),
			РежимДиалогаВопрос.ОКОтмена,
			60,
			КодВозвратаДиалога.ОК,,
			КодВозвратаДиалога.Отмена);
	Иначе 
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Отмена);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ФормулыРасчетаСуммаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ФормулыРасчета.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РучнойВвод = ПредопределенноеЗначение("Перечисление.СпособыРасчетаПоказателяФормулы.РучнойВвод");
	Если НЕ ТекущиеДанные.СпособРасчета = РучнойВвод Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.РучноеЗначение		= ТекущиеДанные.Сумма;
	ТекущиеДанные.РасчетПредставление	= РаботаСФормуламиКлиентСервер.ПолучитьРасчетПредставление(ТекущиеДанные);
	
	ВыполнитьПересчетДанныхТаблицыФормул(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
    УстановитьОформлениеТаблицыФормулыНаСервере();

	Если Объект.Ссылка.Пустая() Тогда
		ДополнитьФормулыРасчетаПредопределеннымиЭлементамиНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьРасчет(Команда)
	ВыполнитьПересчетДанныхТаблицыФормул(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ЗавершениеНемодальныхВызовов
	 
&НаКлиенте
Процедура РедактироватьФормулуЗавершение(ДанныеИзменились, ДопПараметры) Экспорт	
	Если НЕ ДанныеИзменились = Истина Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьПересчетДанныхТаблицыФормул(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте 
Процедура ФормулыРасчетаПередУдалениемВопросЗавершение(Результат, ДопПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТаблицы = Объект.ФормулыРасчета.НайтиПоИдентификатору(ДопПараметры.ИдентификаторСтроки);
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ИндексСтроки = Объект.ФормулыРасчета.Индекс(СтрокаТаблицы);
	Объект.ФормулыРасчета.Удалить(ИндексСтроки);

	ВыполнитьПересчетДанныхТаблицыФормул(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте 
Процедура РедактироватьФормулу(знач СтрокаФормулы)
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("Идентификатор"	, СтрокаФормулы.Идентификатор);
	ДопПараметры.Вставить("Колонка"			, СтрокаФормулы.Колонка);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("РедактироватьФормулуЗавершение", ЭтотОбъект, ДопПараметры);
	
	ПараметрыРедактирования = РаботаСФормуламиКлиент.ПараметрыРедактирования(ЭтотОбъект);
	ПараметрыРедактирования.ФормулыРасчета			= Объект.ФормулыРасчета;
	ПараметрыРедактирования.СтрокаФормулы			= СтрокаФормулы;
	ПараметрыРедактирования.Показатели				= ПолучитьДополнительныеПоказателиДляРедактирования();
	ПараметрыРедактирования.Оповещение				= ОписаниеОповещения;
	ПараметрыРедактирования.ТолькоПросмотр			= ЭтотОбъект.ТолькоПросмотрФормулы;
	ПараметрыРедактирования.ЗапретитьПоказатель		= СтрокаФормулы.Предопределенный;
	ПараметрыРедактирования.РазрешитьПустоеЗначение	= СтрокаФормулы.Предопределенный;
	
	РаботаСФормуламиКлиент.РедактироватьФормулу(ПараметрыРедактирования);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста 
Процедура ВыполнитьПересчетДанныхТаблицыФормул(Форма)                                               
	Показатели = ПолучитьДополнительныеПоказателиДляРасчета(Форма.Объект);
	
	ДанныеДляРасчета = РаботаСФормуламиКлиентСервер.ПодготовитьДанныеДляРасчета(Форма.Объект.ФормулыРасчета, "Представление,Значение,РасчетПредставление");
	РезультатРасчета = РаботаСФормуламиКлиентСервер.ВыполнитьРасчетФормул(ДанныеДляРасчета, Показатели);
	
	Если НЕ РезультатРасчета.Выполнено Тогда
		РаботаСФормуламиКлиентСервер.СообщитьРезультатРасчета(РезультатРасчета);
		Возврат;
	КонецЕсли;
	
	РасчетФормулы = ПредопределенноеЗначение("Перечисление.СпособыРасчетаПоказателяФормулы.Формула");
	
	Для Каждого СтрокаТаблицы Из Форма.Объект.ФормулыРасчета Цикл
		Если СтрокаТаблицы.СпособРасчета = РасчетФормулы Тогда
			КлючФормулы		= РаботаСФормуламиКлиентСервер.ПолучитьКлючФормулы(СтрокаТаблицы.Идентификатор, СтрокаТаблицы.Колонка);
			ДанныеРасчета	= РезультатРасчета.Результат.Получить(КлючФормулы);
			
			Если ДанныеРасчета = Неопределено Тогда
				СтрокаТаблицы.Сумма = 0;
			Иначе 
				СтрокаТаблицы.Сумма = ДанныеРасчета.Результат;
			КонецЕсли;
		Иначе 
			СтрокаТаблицы.Сумма = СтрокаТаблицы.РучноеЗначение;
		КонецЕсли;
	КонецЦикла;
	
	Форма.Модифицированность = Истина;
	
	#Если Клиент Тогда
	ПоказатьОповещениеПользователя(НСтр("ru='Выполнен пересчет'"),,
		НСтр("ru='Настройки изменились. Произведен пересчет данных по формулам.'"),
		БиблиотекаКартинок.Информация32);
	#КонецЕсли 
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста 
Функция ПолучитьДополнительныеПоказателиДляРедактирования()
	Показатели = Новый Структура;
	
	РаботаСФормуламиКлиентСервер.ДобавитьГруппуПоказателей(Показатели,
		"ПоказателиДокумента",
		НСтр("ru='Показатели документа'"));
		
	РаботаСФормуламиКлиентСервер.ДобавитьПоказательВГруппу(Показатели.ПоказателиДокумента,
		"ДатаДокумента",
		НСтр("ru='Дата документа'"));
		
	РаботаСФормуламиКлиентСервер.ДобавитьПоказательВГруппу(Показатели.ПоказателиДокумента,
		"СекундНачДня",
		НСтр("ru='Секунд с начала дня'"));
		
	Возврат Показатели;
КонецФункции

&НаКлиентеНаСервереБезКонтекста 
Функция ПолучитьДополнительныеПоказателиДляРасчета(знач ДокОбъект)              
	Показатели = Новый Соответствие;
	Показатели.Вставить("ДатаДокумента"	, ДокОбъект.Дата);
	Показатели.Вставить("СекундНачДня"	, ДокОбъект.Дата - НачалоДня(ДокОбъект.Дата));
		
	Возврат Показатели;
КонецФункции

&НаСервере 
Процедура УстановитьОформлениеТаблицыФормулыНаСервере()
	
	Шрифт_Ж = Новый Шрифт(Элементы.ФормулыРасчета.Шрифт,,, Истина);
	
	#Область Предопределенный
	ЭлементУО = ЭтотОбъект.УсловноеОформление.Элементы.Добавить();
	ЭлементУО.Использование = Истина;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭлементУО.Отбор,
		"Объект.ФормулыРасчета.Предопределенный", Истина, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Шрифт", Шрифт_Ж);
	
	РаботаСФормамиПТБКлиентСервер.ДобавитьПоляУсловногоОформления(ЭлементУО.Поля, "ФормулыРасчета");
	#КонецОбласти
	
	#Область СпособРасчетаФормула
	ЭлементУО = ЭтотОбъект.УсловноеОформление.Элементы.Добавить();
	ЭлементУО.Использование = Истина;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭлементУО.Отбор,
		"Объект.ФормулыРасчета.СпособРасчета",
		ПредопределенноеЗначение("Перечисление.СпособыРасчетаПоказателяФормулы.Формула"),
		ВидСравненияКомпоновкиДанных.Равно,,
		Истина);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	РаботаСФормамиПТБКлиентСервер.ДобавитьПоляУсловногоОформления(ЭлементУО.Поля, "ФормулыРасчетаСумма");
	#КонецОбласти
	
КонецПроцедуры

&НаСервере 
Процедура ДополнитьФормулыРасчетаПредопределеннымиЭлементамиНаСервере()
	РучноеЗначение	= Перечисления.СпособыРасчетаПоказателяФормулы.РучнойВвод;
	РасчетПоФормуле	= Перечисления.СпособыРасчетаПоказателяФормулы.Формула;
	
	ТарифОписание = НСтр("ru='Заработная плата, надбавки и доплаты, премии и вознаграждения"
		+ ", оплата отпусков, компенсационные выплаты, связанные с режимом работы и условиями"
		+ " труда и другие выплаты, включаемые в фонд оплаты труда основных рабочих'");
		
	НалогиОписание = НСтр("ru='Социальное и медицинское страхование, взносы в пенсионные фонды"
		+ " и другие выплаты во внебюджетные фонды'");
		
	КосвенныеОписание = НСтр("ru='Косвенные затраты на 1 чел-час'"); 
		
	СтоимостьОписание = НСтр("ru='Полная стоимость прямых затрат на ч/ч'");
	
	ДобавитьСтрокуФормулы(Объект, "Тариф_ЧЧ"	, НСтр("ru='Тариф'"),
		РучноеЗначение, 0,
		"Тариф_ЧЧ", ТарифОписание,
		Ложь, 2, Истина);
		
	ДобавитьСтрокуФормулы(Объект, "СтавкаНалоги_ЧЧ", НСтр("ru='Ставка отчислений во внебюджетные фонды'"),
		РучноеЗначение, 30.05,
		"СтавкаНалоги_ЧЧ", НСтр("ru='Средняя ставка отчислений во внебюджетные фонды'") ,
		Ложь, 2, Истина);
		
	ДобавитьСтрокуФормулы(Объект, "Налоги_ЧЧ", НСтр("ru='Отчисления во внебюджетные фонды'"),
		РасчетПоФормуле, "Тариф_ЧЧ * СтавкаНалоги_ЧЧ / 100",
		"Налоги_ЧЧ", НалогиОписание,
		Ложь, 2, Истина);
		
	ДобавитьСтрокуФормулы(Объект, "Косвенные_ЧЧ", НСтр("ru='Косвенные затраты на 1 чел-час'"),
		РучноеЗначение, 0,
		"Косвенные_ЧЧ", КосвенныеОписание,
		Ложь, 2, Истина);
		
	ДобавитьСтрокуФормулы(Объект, "Стоимость_ЧЧ", НСтр("ru='Стоимость 1 чел-часа'"),
		РасчетПоФормуле, "Тариф_ЧЧ + Налоги_ЧЧ + Косвенные_ЧЧ",
		"Стоимость_ЧЧ", СтоимостьОписание,
		Ложь, 2, Истина, Истина);
КонецПроцедуры

&НаСервере 
Процедура ДобавитьСтрокуФормулы(ЭлементОбъект, знач Идентификатор, знач Представление,
	знач СпособРасчета, знач ФормулаЗначение = Неопределено,
	знач ИмяПоказателя = "", знач Описание = "", 
	знач НеОкруглять = Истина, знач Точность = 2, знач НеОтрицательное = Истина, 
	знач Предопределенный = Ложь)
	
	МассивСтрокФормул = ЭлементОбъект.ФормулыРасчета.НайтиСтроки(Новый Структура("Идентификатор", Идентификатор));
	Если МассивСтрокФормул.Количество() = 0 Тогда
		СтрокаТаблицы = ЭлементОбъект.ФормулыРасчета.Добавить();
	Иначе 
		СтрокаТаблицы = МассивСтрокФормул[0];
	КонецЕсли;
	
	СтрокаТаблицы.Идентификатор	 		= Идентификатор;
	СтрокаТаблицы.Представление			= Представление;
	СтрокаТаблицы.СпособРасчета			= СпособРасчета;
	СтрокаТаблицы.НеОкруглять			= НеОкруглять;
	СтрокаТаблицы.НеОтрицательное		= НеОтрицательное;
	СтрокаТаблицы.ТочностьОкругления	= Точность;
	СтрокаТаблицы.Предопределенный		= Предопределенный;
	
	Если СтрокаТаблицы.СпособРасчета = Перечисления.СпособыРасчетаПоказателяФормулы.РучнойВвод Тогда
		СтрокаТаблицы.РучноеЗначение = ФормулаЗначение;
	ИначеЕсли СтрокаТаблицы.СпособРасчета = Перечисления.СпособыРасчетаПоказателяФормулы.Формула Тогда
		СтрокаТаблицы.Формула = ФормулаЗначение;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ИмяПоказателя) Тогда
		СтрокаТаблицы.ЭтоПоказатель			= Истина;
		СтрокаТаблицы.ИмяПоказателя			= ИмяПоказателя;
		СтрокаТаблицы.ОписаниеПоказателя	= Описание;
	КонецЕсли;
	
	СтруктураФормулы = РаботаСФормуламиКлиентСервер.СтруктураФормулы();
	ЗаполнитьЗначенияСвойств(СтруктураФормулы, СтрокаТаблицы);
	
	СтрокаТаблицы.РасчетПредставление = РаботаСФормуламиКлиентСервер.ПолучитьРасчетПредставление(СтруктураФормулы);
КонецПроцедуры

#КонецОбласти


