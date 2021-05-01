﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыАдминистрирования, ФайлыИсправлений;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ОбновлениеКонфигурации.ЕстьПраваНаУстановкуОбновления() Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для обновления конфигурации. Обратитесь к администратору.'");
	ИначеЕсли Пользователи.ЭтоСеансВнешнегоПользователя() Тогда
		ВызватьИсключение НСтр("ru = 'Данная операция не доступна внешнему пользователю системы.'");
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ЭтоWindowsКлиент() Тогда
		Возврат; // Отказ устанавливается в ПриОткрытии().
	КонецЕсли;
	
	ЭтоФайловаяБаза = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	ЭтоПодчиненныйУзелРИБ = ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ();
	
	// Если это первый запуск после обновления конфигурации, то запоминаем и сбрасываем статус.
	Объект.РезультатОбновления = ОбновлениеКонфигурации.ОбновлениеКонфигурацииУспешно(КаталогСкрипта);
	Если Объект.РезультатОбновления <> Неопределено Тогда
		ОбновлениеКонфигурации.СброситьСтатусОбновленияКонфигурации();
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		Элементы.ПанельПочта.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.НадписьВыявленныеПроблемы.Видимость = ЕстьПроблемыСистемныхПроверок();
	Элементы.НадписьЕстьРасширения.Видимость     = ОбновлениеКонфигурации.ПредупреждатьОНаличииРасширений();
	
	Элементы.ПанельПредупреждений.Видимость = Элементы.НадписьВыявленныеПроблемы.Видимость
		Или Элементы.НадписьЕстьРасширения.Видимость;
	
	// Проверяем каждый раз при открытии помощника.
	КонфигурацияИзменена = КонфигурацияИзменена();
	НуженФайлОбновления = ?(КонфигурацияИзменена, 0, 1);
	
	Если Параметры.ЗавершениеРаботыСистемы Тогда
		Элементы.ПереключательОбновленияФайл.Видимость = Ложь;
		Элементы.ПереключательОбновленияСервер.Видимость = Ложь;
		Элементы.ПолеДатаВремяОбновления.Видимость = Ложь;
		Элементы.НадписьНажмитеДалее.Видимость = Истина;
	КонецЕсли;
	
	Если Параметры.ПолученоОбновлениеКонфигурации Тогда
		Элементы.СтраницыСпособОбновленияФайл.ТекущаяСтраница = Элементы.СтраницаПолученоОбновлениеИзПриложенияФайл;
	КонецЕсли;
	
	Элементы.НадписьОбновлениеКонфигурацииВыполняетсяПриОбменеДаннымиСГлавнымУзлом.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Элементы.НадписьОбновлениеКонфигурацииВыполняетсяПриОбменеДаннымиСГлавнымУзлом.Заголовок, ПланыОбмена.ГлавныйУзел());
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПустаяСтрока(Параметры.ВыбранныеФайлы) Тогда 
		ВосстановитьНастройкиОбновленияКонфигурации();
	Иначе 
		ВыбранныеФайлы = Параметры.ВыбранныеФайлы;
	КонецЕсли;
	
	Если ЭтоФайловаяБаза И Объект.РежимОбновления > 1 Или Параметры.ЗавершениеРаботыСистемы Тогда
		Объект.РежимОбновления = 0;
	КонецЕсли;
	
	Элементы.ПоискИУстановкаОбновлений.Видимость = ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы");
	
	ДоступнаУстановкаПатчейВБазовойВерсии = СтандартныеПодсистемыСервер.ДоступнаУстановкаПодписанныхРасширенийВБазовойВерсии();
	ЭтоБазоваяВерсия = СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации();
	Если ЭтоБазоваяВерсия И Не ДоступнаУстановкаПатчейВБазовойВерсии Тогда
		ЗаголовокВариантаВыбора = НСтр("ru = 'Укажите файл обновления'");
		Элементы.ПереключательНуженФайлОбновления.СписокВыбора[1].Представление = ЗаголовокВариантаВыбора;
	КонецЕсли;
	
	ЗаполнитьПанельИнформации();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПанельИнформации()
	
	Видимость = Ложь;
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтрольВеденияУчета") Тогда
		МодульКонтрольВеденияУчетаСлужебный = ОбщегоНазначения.ОбщийМодуль("КонтрольВеденияУчетаСлужебный");
		Информация = МодульКонтрольВеденияУчетаСлужебный.ИнформацияОСистемныхПроверкахВеденияУчета();
		Если Информация.ПредупреждатьОНеобходимостиПовторнойПроверки Тогда
			Если ЗначениеЗаполнено(Информация.ДатаПоследнейПроверки) Тогда
				Подсказка = НСтр("ru = 'Последняя системная проверка выполнялась %1.'");
				Подсказка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Подсказка, 
					Формат(Информация.ДатаПоследнейПроверки, "ДЛФ=Д"));
			Иначе
				Подсказка = "";
			КонецЕсли;
			Элементы.НадписьИнформация.РасширеннаяПодсказка.Заголовок = Подсказка;
			Видимость = Истина;
		КонецЕсли;
	КонецЕсли;
	Элементы.ПанельИнформации.Видимость = Видимость;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Инициализация переменных.
	ФайлыИсправлений = Новый Массив;
	Если Не ПустаяСтрока(ФайлыИсправленийСтрокой) Тогда
		ФайлыИсправлений = СтрРазделить(ФайлыИсправленийСтрокой, ",");
	КонецЕсли;
	
	Результат = ОбновлениеКонфигурацииКлиент.ПоддерживаетсяУстановкаОбновлений();
	Если Не Результат.Поддерживается Тогда
		ПоказатьПредупреждение(, Результат.ОписаниеОшибки);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Параметры.ВыполнитьОбновление Тогда
		ПерейтиКВыборуРежимаОбновления();
		Возврат;
	КонецЕсли;
	
	Страницы    = Элементы.СтраницыПомощника.ПодчиненныеЭлементы;
	ИмяСтраницы = Страницы.ФайлОбновления.Имя;
	
	Если ЭтоПодчиненныйУзелРИБ Тогда
		Если КонфигурацияИзменена Тогда
			ПерейтиКВыборуРежимаОбновления();
			Возврат;
		КонецЕсли;
		ИмяСтраницы = Страницы.ОбновленияНеОбнаружено.Имя;
	КонецЕсли;
	
	ПередОткрытиемСтраницы(Страницы[ИмяСтраницы]);
	Элементы.СтраницыПомощника.ТекущаяСтраница = Страницы[ИмяСтраницы];
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Обработка.АктивныеПользователи.Форма.АктивныеПользователи") Тогда
		ОбновитьИнформациюОНаличииСоединений();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЛегальностьПолученияОбновлений" И Не Параметр Тогда
		ОтработатьНажатиеКнопкиНазад();
	ИначеЕсли ИмяСобытия = "КонтрольВеденияУчета_УспешнаяПроверка" Тогда
		ЗаполнитьПанельИнформации();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеКонфигурацииКлиент.ЗаписатьСобытияВЖурналРегистрации();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

////////////////////////////////////////////////////////////////////////////////
// Страница ФайлОбновления

&НаКлиенте
Процедура ПереключательНуженФайлОбновленияПриИзменении(Элемент)
	ПередОткрытиемСтраницы();
КонецПроцедуры

&НаКлиенте
Процедура ПолеФайлОбновленияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьФайлОбновления();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Страница ПослеУстановкиИсправлений

&НаКлиенте
Процедура ДекорацияАктивныеПользователиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПоказатьАктивныхПользователей();
КонецПроцедуры

&НаКлиенте
Процедура НадписьОшибкаУстановкиИсправленийОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОтборЖурнала = Новый Структура;
	ОтборЖурнала.Вставить("СобытиеЖурналаРегистрации", НСтр("ru = 'Исправления.Установка'"));
	ЖурналРегистрацииКлиент.ОткрытьЖурналРегистрации(ОтборЖурнала);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Страница ВыборРежимаОбновленияФайл

&НаКлиенте
Процедура НадписьСписокДействийНажатие(Элемент)
	ПоказатьАктивныхПользователей();
КонецПроцедуры

&НаКлиенте
Процедура НадписьСписокДействий1Нажатие(Элемент)
	ПоказатьАктивныхПользователей();
КонецПроцедуры

&НаКлиенте
Процедура НадписьСписокДействий3Нажатие(Элемент)
	ПоказатьАктивныхПользователей();
КонецПроцедуры

&НаКлиенте
Процедура НадписьРезервнаяКопияНажатие(Элемент)
	
	ПараметрыРезервногоКопирования = Новый Структура;
	ПараметрыРезервногоКопирования.Вставить("СоздаватьРезервнуюКопию",           Объект.СоздаватьРезервнуюКопию);
	ПараметрыРезервногоКопирования.Вставить("ИмяКаталогаРезервнойКопииИБ",       Объект.ИмяКаталогаРезервнойКопииИБ);
	ПараметрыРезервногоКопирования.Вставить("ВосстанавливатьИнформационнуюБазу", Объект.ВосстанавливатьИнформационнуюБазу);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияФормыРезервногоКопирования", ЭтотОбъект);
	ОбновлениеКонфигурацииКлиент.ПоказатьРезервноеКопирование(ПараметрыРезервногоКопирования, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияФормыРезервногоКопирования(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Объект, Результат);
		Элементы.НадписьРезервнаяКопияФайл.Заголовок = ОбновлениеКонфигурацииКлиент.ЗаголовокСозданияРезервнойКопии(Результат);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Страница ВыборРежимаОбновленияСервер

&НаКлиенте
Процедура ПереключательОбновленияПриИзменении(Элемент)
	ПередОткрытиемСтраницы();
КонецПроцедуры

&НаКлиенте
Процедура ВыслатьОтчетНаПочтуПриИзменении(Элемент)
	ПередОткрытиемСтраницы();
КонецПроцедуры

&НаКлиенте
Процедура НадписьОтложенныеОбработчикиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбновлениеИнформационнойБазыКлиент.ПоказатьОтложенныеОбработчики();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВыявленныеПроблемыОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.КонтрольВеденияУчета") Тогда
		МодульКонтрольВеденияУчетаСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("КонтрольВеденияУчетаСлужебныйКлиент");
		МодульКонтрольВеденияУчетаСлужебныйКлиент.ОткрытьОтчетПоПроблемамИзОбработкиОбновления(ЭтотОбъект, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьИнформацияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.КонтрольВеденияУчета") Тогда
		МодульКонтрольВеденияУчетаСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("КонтрольВеденияУчетаСлужебныйКлиент");
		МодульКонтрольВеденияУчетаСлужебныйКлиент.ОткрытьСписокПроверокВеденияУчета();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьЕстьРасширенияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("ОбщаяФорма.Расширения");
КонецПроцедуры

&НаСервере
Функция ЕстьПроблемыСистемныхПроверок()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтрольВеденияУчета") Тогда
		МодульКонтрольВеденияУчетаСлужебный = ОбщегоНазначения.ОбщийМодуль("КонтрольВеденияУчетаСлужебный");
		Возврат МодульКонтрольВеденияУчетаСлужебный.ЕстьПроблемыСистемныхПроверок();
	КонецЕсли;
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КнопкаНазадНажатие(Команда)
	ОтработатьНажатиеКнопкиНазад();
КонецПроцедуры

&НаКлиенте
Процедура КнопкаДалееНажатие(Команда)
	ОбработатьНажатиеКнопкиДалее();
КонецПроцедуры

&НаКлиенте
Процедура ПоискИУстановкаОбновлений(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы") Тогда
		Закрыть();
		МодульПолучениеОбновленийПрограммыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПолучениеОбновленийПрограммыКлиент");
		МодульПолучениеОбновленийПрограммыКлиент.ОбновитьПрограмму();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПередОткрытиемСтраницы(НоваяТекущаяСтраница = Неопределено)
	
	ИмяПараметра = "СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Новый СписокЗначений);
	КонецЕсли;
	
	Страницы = Элементы.СтраницыПомощника.ПодчиненныеЭлементы;
	Если НоваяТекущаяСтраница = Неопределено Тогда
		НоваяТекущаяСтраница = Элементы.СтраницыПомощника.ТекущаяСтраница;
	КонецЕсли;
	
	ДоступностьКнопкиНазад = Истина;
	ДоступностьКнопкиДалее = Истина;
	ДоступностьКнопкиЗакрыть = Истина;
	ФункцияКнопкиДалее = Истина; // Истина = "Далее", Ложь = "Готово"
	ФункцияКнопкиЗакрыть = Истина; // Истина = "Отмена", Ложь = "Закрыть"
	
	Элементы.КнопкаДалее.Отображение = ОтображениеКнопки.Текст;
	
	Если НоваяТекущаяСтраница = Страницы.ОбновленияНеОбнаружено Тогда
		
		ФункцияКнопкиДалее = Ложь;
		ФункцияКнопкиЗакрыть = Ложь;
		ДоступностьКнопкиДалее = Ложь;
		ОписаниеТекущейКонфигурации = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().СинонимКонфигурации;
		ВерсияТекущейКонфигурации = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ВерсияКонфигурации;
		
		Если Не СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ЭтоГлавныйУзел Тогда
			ДоступностьКнопкиНазад = Ложь;
		КонецЕсли;
		
	ИначеЕсли НоваяТекущаяСтраница = Страницы.ВыборРежимаОбновленияФайл Тогда
		
		ФункцияКнопкиДалее = (Объект.РежимОбновления = 0);// Если Не обновляем сейчас, то "готово".
		
		ОбновитьИнформациюОНаличииСоединений(Страницы.ВыборРежимаОбновленияФайл);
		
		Если Объект.СоздаватьРезервнуюКопию = 2 Тогда
			Объект.ВосстанавливатьИнформационнуюБазу = Истина;
		ИначеЕсли Объект.СоздаватьРезервнуюКопию = 0 Тогда
			Объект.ВосстанавливатьИнформационнуюБазу = Ложь;
		КонецЕсли;
		
		Элементы.НадписьРезервнаяКопияФайл.Заголовок = ОбновлениеКонфигурацииКлиент.ЗаголовокСозданияРезервнойКопии(Объект);
		
		Если Не СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ЭтоГлавныйУзел Тогда
			ДоступностьКнопкиНазад = Ложь;
		КонецЕсли;
	ИначеЕсли НоваяТекущаяСтраница = Страницы.ВыборРежимаОбновленияСервер Тогда
		
		ФункцияКнопкиДалее = (Объект.РежимОбновления = 0);// Если не обновляем сейчас, то "готово".
		Объект.ВосстанавливатьИнформационнуюБазу = Ложь;
		
		СтраницыПанелиИнформацииПерезагрузки = Элементы.СтраницыИнформацииПерезагрузки.ПодчиненныеЭлементы;
		Элементы.СтраницыИнформацииПерезагрузки.ТекущаяСтраница = ?(Объект.РежимОбновления = 0,
			СтраницыПанелиИнформацииПерезагрузки.СтраницаПерезагрузкиСейчас,
			СтраницыПанелиИнформацииПерезагрузки.СтраницаЗапланированнойПерезагрузки);
		
		ОбновитьИнформациюОНаличииСоединений(Страницы.ВыборРежимаОбновленияСервер);
		
		Элементы.ПолеДатаВремяОбновления.Доступность = (Объект.РежимОбновления = 2);
		Элементы.АдресЭлектроннойПочты.Доступность   = Объект.ВыслатьОтчетНаПочту;
		
		Если Не СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ЭтоГлавныйУзел Тогда
			ДоступностьКнопкиНазад = Ложь;
		КонецЕсли;
		
		Если Объект.РежимОбновления = 2 Тогда 
			Элементы.КнопкаДалее.Отображение = ОтображениеКнопки.КартинкаИТекст;
		КонецЕсли;
		
	ИначеЕсли НоваяТекущаяСтраница = Страницы.ФайлОбновления Тогда
		
		ДоступностьКнопкиНазад = Ложь;
		
		Если НуженФайлОбновления = 0 Тогда
			Если КонфигурацияИзменена Тогда
				Элементы.СтраницыНадписиИзмененнойКонфигурации.ТекущаяСтраница = Элементы.ЕстьИзменения;
			Иначе
				Элементы.СтраницыНадписиИзмененнойКонфигурации.ТекущаяСтраница = Элементы.НетИзменений;
				ДоступностьКнопкиДалее = Ложь;
			КонецЕсли;
		ИначеЕсли НуженФайлОбновления = 1 Тогда
			ТекущийЭлемент = Элементы.ПолеФайлОбновления;
			Если ПустаяСтрока(ВыбранныеФайлы) Тогда
				ПодключитьОбработчикОжидания("ВыбратьФайлОбновления", 0.1, Истина);
			КонецЕсли;
		КонецЕсли;
		Элементы.ПанельОбновлениеИзОсновнойКонфигурации.Видимость = НуженФайлОбновления = 0;
		Элементы.ПолеФайлОбновления.Доступность                   = НуженФайлОбновления = 1;
		Элементы.ПолеФайлОбновления.АвтоОтметкаНезаполненного     = НуженФайлОбновления = 1;
		
	КонецЕсли;
	
	ОбновлениеКонфигурацииКлиент.ЗаписатьСобытияВЖурналРегистрации();
	
	КнопкаДалее = Элементы.КнопкаДалее;
	КнопкаЗакрыть = Элементы.КнопкаЗакрыть;
	Элементы.КнопкаНазад.Доступность = ДоступностьКнопкиНазад;
	КнопкаДалее.Доступность   = ДоступностьКнопкиДалее;
	КнопкаЗакрыть.Доступность = ДоступностьКнопкиЗакрыть;
	Если ДоступностьКнопкиДалее Тогда
		Если Не КнопкаДалее.КнопкаПоУмолчанию Тогда
			КнопкаДалее.КнопкаПоУмолчанию = Истина;
		КонецЕсли;
	ИначеЕсли ДоступностьКнопкиЗакрыть Тогда
		Если Не КнопкаЗакрыть.КнопкаПоУмолчанию Тогда
			КнопкаЗакрыть.КнопкаПоУмолчанию = Истина;
		КонецЕсли;
	КонецЕсли;
	
	КнопкаДалее.Заголовок = ?(ФункцияКнопкиДалее, НСтр("ru = 'Далее >'"), НСтр("ru = 'Готово'"));
	КнопкаЗакрыть.Заголовок = ?(ФункцияКнопкиЗакрыть, НСтр("ru = 'Отмена'"), НСтр("ru = 'Закрыть'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайлОбновления()
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Каталог = ПолучитьКаталогФайла(Элементы.ПолеФайлОбновления.ТекстРедактирования);
	Диалог.ПроверятьСуществованиеФайла = Истина;
	Если ЭтоБазоваяВерсия И Не ДоступнаУстановкаПатчейВБазовойВерсии Тогда
		Диалог.Фильтр = НСтр("ru = 'Все файлы поставки (*.cf*;*.cfu)|*.cf*;*.cfu|Файлы поставки конфигурации (*.cf)|*.cf|Файлы поставки обновления конфигурации(*.cfu)|*.cfu'");
	Иначе
		Диалог.МножественныйВыбор = Истина;
		Диалог.Фильтр = НСтр("ru = 'Все файлы (*.cf*;*.cfu;*.cfe;*.zip)|*.cf*;*.cfu;*.cfe;*.zip|Файлы поставки конфигурации (*.cf)|*.cf|Файлы поставки обновления конфигурации (*.cfu)|*.cfu|Файлы исправлений (*.cfe*;*.zip)|*.cfe*;*.zip'");
	КонецЕсли;
	Диалог.Заголовок = НСтр("ru = 'Выбор поставки обновления конфигурации'");
	
	Если Диалог.Выбрать() Тогда
		ВыбранныеФайлы = СтрСоединить(Диалог.ВыбранныеФайлы, ",");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформациюОНаличииСоединений(ТекущаяСтраница = Неопределено)
	
	Если ТекущаяСтраница = Неопределено Тогда
		ТекущаяСтраница = Элементы.СтраницыПомощника.ТекущаяСтраница;
	КонецЕсли;
	
	ИмяПараметра = "СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации";
	Если ТекущаяСтраница = Элементы.ВыборРежимаОбновленияФайл Тогда
		
		СоединенияИнфо = СоединенияИБВызовСервера.ИнформацияОСоединениях(Ложь, ПараметрыПриложения[ИмяПараметра]);
		Элементы.ГруппаСоединений.Видимость = СоединенияИнфо.НаличиеАктивныхСоединений;
		
		Если СоединенияИнфо.НаличиеАктивныхСоединений Тогда
			ВсеСтраницы = Элементы.ПанельАктивныеПользователи.ПодчиненныеЭлементы;
			Если СоединенияИнфо.НаличиеCOMСоединений Тогда
				Элементы.ПанельАктивныеПользователи.ТекущаяСтраница = ВсеСтраницы.АктивныеСоединения;
			ИначеЕсли СоединенияИнфо.НаличиеСоединенияКонфигуратором Тогда
				Элементы.ПанельАктивныеПользователи.ТекущаяСтраница = ВсеСтраницы.СоединениеКонфигуратора;
			Иначе
				Элементы.ПанельАктивныеПользователи.ТекущаяСтраница = ВсеСтраницы.АктивныеПользователи;
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ТекущаяСтраница = Элементы.ВыборРежимаОбновленияСервер Тогда
		
		ПараметрыСтраницы = ПараметрыСтраницыВыборРежимаОбновленияСервер(ПараметрыПриложения[ИмяПараметра]);
		Элементы.НадписьОтложенныеОбработчики.Видимость = ПараметрыСтраницы.ЕстьОтложенныеОбработчики;
		
		СоединенияИнфо = ПараметрыСтраницы.ИнформацияОСоединениях;
		НаличиеСоединений = СоединенияИнфо.НаличиеАктивныхСоединений И Объект.РежимОбновления = 0;
		Элементы.ГруппаСоединений1.Видимость = НаличиеСоединений;
		Если НаличиеСоединений Тогда
			ВсеСтраницы = Элементы.ПанельАктивныеПользователи1.ПодчиненныеЭлементы;
			Элементы.ПанельАктивныеПользователи1.ТекущаяСтраница = ? (СоединенияИнфо.НаличиеCOMСоединений, 
				ВсеСтраницы.АктивныеСоединения1, ВсеСтраницы.АктивныеПользователи1);
		КонецЕсли;
		
	ИначеЕсли ТекущаяСтраница = Элементы.ПослеУстановкиИсправлений Тогда
		
		СоединенияИнфо = СоединенияИБВызовСервера.ИнформацияОСоединениях(Ложь, ПараметрыПриложения[ИмяПараметра]);
		Элементы.ДекорацияАктивныеПользователи.Видимость = СоединенияИнфо.НаличиеАктивныхСоединений;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОбновление()
	
	ПараметрыОбновления = Новый Структура;
	ПараметрыОбновления.Вставить("РежимОбновления");
	ПараметрыОбновления.Вставить("ДатаВремяОбновления");
	ПараметрыОбновления.Вставить("ВыслатьОтчетНаПочту");
	ПараметрыОбновления.Вставить("АдресЭлектроннойПочты");
	ПараметрыОбновления.Вставить("КодЗадачиПланировщика");
	ПараметрыОбновления.Вставить("СоздаватьРезервнуюКопию");
	ПараметрыОбновления.Вставить("ИмяКаталогаРезервнойКопииИБ");
	ПараметрыОбновления.Вставить("ВосстанавливатьИнформационнуюБазу");
	ПараметрыОбновления.Вставить("ИмяФайлаОбновления");
	
	ЗаполнитьЗначенияСвойств(ПараметрыОбновления, Объект);
	ПараметрыОбновления.Вставить("ЗавершениеРаботыСистемы", Параметры.ЗавершениеРаботыСистемы);
	ПараметрыОбновления.Вставить("НуженФайлОбновления", Булево(НуженФайлОбновления));
	ПараметрыОбновления.Вставить("ФайлыИсправлений", ФайлыИсправлений);
	
	ОбновлениеКонфигурацииКлиент.УстановитьОбновление(ЭтотОбъект, ПараметрыОбновления, ПараметрыАдминистрирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНажатиеКнопкиДалее()
	
	ОчиститьСообщения();
	ТекущаяСтраница = Элементы.СтраницыПомощника.ТекущаяСтраница;
	Страницы = Элементы.СтраницыПомощника.ПодчиненныеЭлементы;
	
	Если ТекущаяСтраница = Страницы.ФайлОбновления Тогда
		ПерейтиСоСтраницыФайлаОбновления();
	ИначеЕсли ТекущаяСтраница = Страницы.ВыборРежимаОбновленияФайл
		Или ТекущаяСтраница = Страницы.ВыборРежимаОбновленияСервер Тогда
		УстановитьОбновление();
	ИначеЕсли ТекущаяСтраница = Страницы.ПослеУстановкиИсправлений И ПерезапуститьПрограмму Тогда
		ЗавершитьРаботуСистемы(Истина, Истина);
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтработатьНажатиеКнопкиНазад()
	
	Страницы = Элементы.СтраницыПомощника.ПодчиненныеЭлементы;
	ТекущаяСтраница = Элементы.СтраницыПомощника.ТекущаяСтраница;
	НоваяТекущаяСтраница = ТекущаяСтраница;
	
	Если ТекущаяСтраница = Страницы.ВыборРежимаОбновленияФайл
		Или ТекущаяСтраница = Страницы.ВыборРежимаОбновленияСервер Тогда
		НоваяТекущаяСтраница = Страницы.ФайлОбновления;
	КонецЕсли;
	
	ПередОткрытиемСтраницы(НоваяТекущаяСтраница);
	Элементы.СтраницыПомощника.ТекущаяСтраница = НоваяТекущаяСтраница;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиСоСтраницыФайлаОбновления()
	
	ФайлыИсправлений = Новый Массив;
	Объект.ИмяФайлаОбновления = "";
	Если Не ПустаяСтрока(ИсходныеКонфигурации) Тогда
		УдалитьИзВременногоХранилища(ИсходныеКонфигурации);
		ИсходныеКонфигурации = "";
	КонецЕсли;	
	
	ИменаВыбранныхФайлов = СтрРазделить(ВыбранныеФайлы, ",");
	Для Каждого ИмяФайла Из ИменаВыбранныхФайлов Цикл
		Если СтрЗаканчиваетсяНа(ИмяФайла, ".cfe") Или СтрЗаканчиваетсяНа(ИмяФайла, ".zip") Тогда
			ФайлыИсправлений.Добавить(ИмяФайла);
		Иначе // Это файл обновления.
			Если Не ПустаяСтрока(Объект.ИмяФайлаОбновления) Тогда
				ВызватьИсключение НСтр("ru = 'Допустимо выбирать только один файл обновления.'");
			КонецЕсли;
			Объект.ИмяФайлаОбновления = ИмяФайла;
		КонецЕсли;
	КонецЦикла;
	
	Если НуженФайлОбновления = 1 Тогда
		Если Не ЗначениеЗаполнено(ВыбранныеФайлы) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Укажите файл поставки обновления конфигурации.'"),,"Объект.ИмяФайлаОбновления");
			ТекущийЭлемент = Элементы.ПолеФайлОбновления;
			Возврат;
		КонецЕсли;
		Если Не ПустаяСтрока(Объект.ИмяФайлаОбновления) Тогда
			Файл = Новый Файл(Объект.ИмяФайлаОбновления);
			Если Не Файл.Существует() Или Не Файл.ЭтоФайл() Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Файл поставки обновления конфигурации не найден.'"),,"Объект.ИмяФайлаОбновления");
				ТекущийЭлемент = Элементы.ПолеФайлОбновления;
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ПроверитьПрименимостьФайловОбновления", ЭтотОбъект);
	ПараметрыФормы = Новый Структура("Ключ", "ПередВыборомФайлаОбновления");
	ОткрытьФорму("ОбщаяФорма.ПредупреждениеБезопасности", ПараметрыФормы, , , , , Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПрименимостьФайловОбновления(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> "Продолжить" Тогда
		Возврат;
	КонецЕсли;

	Если ПустаяСтрока(Объект.ИмяФайлаОбновления) Тогда
		Если НуженФайлОбновления = 1 Тогда
			ПерейтиКУстановкеИсправлений();
		Иначе
			ПриПроверкеЛегальностиПолученияОбновления();			
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	// Проверяем применимость файлов поставки обновлений только в файловой базе.
	Если Не ОбщегоНазначенияКлиент.ИнформационнаяБазаФайловая() Тогда
		ПриПроверкеЛегальностиПолученияОбновления();
		Возврат;
	КонецЕсли;	
		
	Если Не ЭтоФайлПоставкиОбновленияКонфигурации(Объект.ИмяФайлаОбновления) Тогда
		ПриПроверкеЛегальностиПолученияОбновления();
		Возврат;
	КонецЕсли;
	
	Состояние(НСтр("ru = 'Проверка применимости...'"), 75);
	СведенияОбОбновлении = ПроверитьПрименимостьФайлаОбновления(Объект.ИмяФайлаОбновления, УникальныйИдентификатор);
	Если Не ПустаяСтрока(СведенияОбОбновлении.ТекстОшибки) Тогда
		ПриПроверкеЛегальностиПолученияОбновления();
		Возврат; // не удалось проверить: возможно, файл поврежден
	КонецЕсли;	
	
	Если СведенияОбОбновлении.Подходит Тогда
		УдалитьИзВременногоХранилища(СведенияОбОбновлении.ИсходныеКонфигурации);
		ПриПроверкеЛегальностиПолученияОбновления();
		Возврат;
	КонецЕсли;
	
	ИсходныеКонфигурации = СведенияОбОбновлении.ИсходныеКонфигурации;
	ОткрытьФорму("Обработка.УстановкаОбновлений.Форма.ОбновлениеНеПодходит",
	 	Новый Структура("ИсходныеКонфигурации", ИсходныеКонфигурации));
	
КонецПроцедуры

&НаКлиенте
Функция ЭтоФайлПоставкиОбновленияКонфигурации(Знач ИмяФайла)
	Возврат СтрСравнить(ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ИмяФайла), "cfu") = 0;
КонецФункции	

&НаСервереБезКонтекста
Функция ПроверитьПрименимостьФайлаОбновления(Знач ИмяФайла, Знач ИдентификаторФормы)
	Результат = ОбновлениеКонфигурации.СведенияОбОбновлении(ИмяФайла);
	Результат.ИсходныеКонфигурации = ПоместитьВоВременноеХранилище(Результат.ИсходныеКонфигурации, ИдентификаторФормы);
	Возврат Результат;	
КонецФункции

&НаКлиенте
Процедура ПерейтиКУстановкеИсправлений()
	
	ЗагружаемыеФайлы = Новый Массив;
	Для Каждого ФайлИсправления Из ФайлыИсправлений Цикл
		ЗагружаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ФайлИсправления));
	КонецЦикла;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПродолжитьУстановкуИсправлений", ЭтотОбъект);
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;
	ПараметрыЗагрузки.Интерактивно = Ложь;
	ФайловаяСистемаКлиент.ЗагрузитьФайлы(ОписаниеОповещения, ПараметрыЗагрузки, ЗагружаемыеФайлы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьУстановкуИсправлений(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	
	УстановитьИсправленияНаСервере(ПомещенныеФайлы);
	
	Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.ПослеУстановкиИсправлений;
	Элементы.КнопкаДалее.Заголовок = НСтр("ru = 'Готово'");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьИсправленияНаСервере(ПомещенныеФайлы)
	
	СоединенияИнфо = СоединенияИБВызовСервера.ИнформацияОСоединениях(Ложь);
	Элементы.ДекорацияАктивныеПользователи.Видимость = СоединенияИнфо.НаличиеАктивныхСоединений;
	
	Исправления = Новый Структура;
	Исправления.Вставить("Установить", ПомещенныеФайлы);
	Результат = ОбновлениеКонфигурации.УстановкаИУдалениеИсправлений(Исправления);
	ЕстьОшибки = (Результат.НеУстановлено <> 0);
	УстановленоИсправлений = Результат.Установленные.Количество();
	Элементы.ОшибкаУстановкиИсправлений.Видимость = ЕстьОшибки;
	Элементы.ПанельПредупреждений.Видимость = Ложь;
	Элементы.ПанельИнформации.Видимость     = Ложь;
	
	Если ЕстьОшибки Тогда
		Если УстановленоИсправлений > 0 Тогда
			ТекстНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Установлено исправлений: %1 из %2, изменения вступят в силу после перезапуска программы'"),
				УстановленоИсправлений,
				ПомещенныеФайлы.Количество());
			Элементы.ДекорацияУстановленоИсправлений.Заголовок = ТекстНадписи;
			Элементы.ДекорацияИсправленияУстановлены.Видимость = Ложь;
		Иначе
			Элементы.ИсправленияУстановлены.Видимость = Ложь;
			Элементы.ДекорацияУстановленоИсправлений.Видимость = Ложь;
			Возврат;
		КонецЕсли;
	Иначе
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга") Тогда
			ИмяОперации = "СтандартныеПодсистемы.ОбновлениеКонфигурации.Патчи.РучнаяУстановкаПатча";
			МодульЦентрМониторинга = ОбщегоНазначения.ОбщийМодуль("ЦентрМониторинга");
			МодульЦентрМониторинга.ЗаписатьОперациюБизнесСтатистики(ИмяОперации, 1);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКВыборуРежимаОбновления(ЭтоПереходДалее = Ложь)
	
	Если ПараметрыАдминистрирования = Неопределено Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПолученияПараметровАдминистрирования", ЭтотОбъект, ЭтоПереходДалее);
		ЗаголовокФормы = НСтр("ru = 'Установка обновления'");
		Если ЭтоФайловаяБаза Тогда
			ПоясняющаяНадпись = НСтр("ru = 'Для установки обновления необходимо ввести
				|параметры администрирования информационной базы'");
			ЗапрашиватьПараметрыАдминистрированияКластера = Ложь;
		Иначе
			ПоясняющаяНадпись = НСтр("ru = 'Для установки обновления необходимо ввести параметры
				|администрирования кластера серверов и информационной базы'");
			ЗапрашиватьПараметрыАдминистрированияКластера = Истина;
		КонецЕсли;
		
		СоединенияИБКлиент.ПоказатьПараметрыАдминистрирования(ОписаниеОповещения, Истина, ЗапрашиватьПараметрыАдминистрированияКластера,
			ПараметрыАдминистрирования, ЗаголовокФормы, ПоясняющаяНадпись);
		
	Иначе
		
		ПослеПолученияПараметровАдминистрирования(ПараметрыАдминистрирования, ЭтоПереходДалее);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПроверкеЛегальностиПолученияОбновления()
	
	Если НуженФайлОбновления = 1 Тогда
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПроверкаЛегальностиПолученияОбновления") Тогда
			Оповещение = Новый ОписаниеОповещения("ПриПроверкеЛегальностиПолученияОбновленияЗавершение", ЭтотОбъект);
			МодульПроверкаЛегальностиПолученияОбновленияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроверкаЛегальностиПолученияОбновленияКлиент");
			МодульПроверкаЛегальностиПолученияОбновленияКлиент.ПоказатьПроверкуЛегальностиПолученияОбновления(Оповещение);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	ПриПроверкеЛегальностиПолученияОбновленияЗавершение(Истина, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПроверкеЛегальностиПолученияОбновленияЗавершение(ОбновлениеПолученоЛегально, ДополнительныеПараметры) Экспорт
	
	Если ОбновлениеПолученоЛегально = Истина Тогда
		ПерейтиКВыборуРежимаОбновления(Истина);
	Иначе
		ОтработатьНажатиеКнопкиНазад();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияПараметровАдминистрирования(Результат, ЭтоПереходДалее) Экспорт
	
	Если ЭтоПереходДалее Тогда
		Элементы.СтраницыПомощника.ТекущаяСтраница.Доступность = Истина;
	КонецЕсли;
	
	Если Результат <> Неопределено Тогда
		
		ПараметрыАдминистрирования = Результат;
		Страницы = Элементы.СтраницыПомощника.ПодчиненныеЭлементы;
		НоваяТекущаяСтраница = ?(ЭтоФайловаяБаза, Страницы.ВыборРежимаОбновленияФайл, Страницы.ВыборРежимаОбновленияСервер);
		УстановитьПарольАдминистратора(ПараметрыАдминистрирования);
		
		ПередОткрытиемСтраницы(НоваяТекущаяСтраница);
		Элементы.СтраницыПомощника.ТекущаяСтраница = НоваяТекущаяСтраница;
		
	Иначе
		
		ТекстПредупреждения = НСтр("ru = 'Для установки обновления необходимо ввести параметры администрирования.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		
		ТекстСообщения = НСтр("ru = 'Не удалось установить обновление программы, т.к. введены неправильные имя или пароль администратора 
			|(или другие параметры администрирования клиент-серверной информационной базы).'");
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(ОбновлениеКонфигурацииКлиент.СобытиеЖурналаРегистрации(), "Ошибка", ТекстСообщения);
		
	КонецЕсли;
	
	ОбновлениеКонфигурацииКлиент.ЗаписатьСобытияВЖурналРегистрации();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьАктивныхПользователей()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОповещатьОЗакрытии", Истина);
	СтандартныеПодсистемыКлиент.ОткрытьСписокАктивныхПользователей(ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыСтраницыВыборРежимаОбновленияСервер(СообщенияДляЖурналаРегистрации)
	
	ПараметрыСтраницы = Новый Структура;
	ПараметрыСтраницы.Вставить("ЕстьОтложенныеОбработчики", (ОбновлениеИнформационнойБазыСлужебный.СтатусНевыполненныхОбработчиков() = "СтатусНеВыполнено"));
	ПараметрыСтраницы.Вставить("ИнформацияОСоединениях", СоединенияИБ.ИнформацияОСоединениях(Ложь, СообщенияДляЖурналаРегистрации));
	Возврат ПараметрыСтраницы;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Планирование обновления в указанное время.

&НаКлиенте
// Возвратить каталог файла - часть пути без имени файла.
//
// Параметры:
//  ПутьКФайлу  - Строка - путь к файлу.
//
// Возвращаемое значение:
//   Строка   - каталог файла
//
Функция ПолучитьКаталогФайла(Знач ПутьКФайлу)
	
	ПозицияСимвола = СтрНайти(ПутьКФайлу, "\", НаправлениеПоиска.СКонца);
	Если ПозицияСимвола > 1 Тогда
		Возврат Сред(ПутьКФайлу, 1, ПозицияСимвола - 1); 
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ВосстановитьНастройкиОбновленияКонфигурации()
	
	Настройки = ОбновлениеКонфигурации.НастройкиОбновленияКонфигурации();
	ЗаполнитьЗначенияСвойств(Объект, Настройки);
	ФайлыИсправленийСтрокой = СтрСоединить(Настройки.ФайлыИсправлений, ",");
	Если ЗначениеЗаполнено(ФайлыИсправленийСтрокой) Тогда
		ВыбранныеФайлы = Настройки.ИмяФайлаОбновления + "," + ФайлыИсправленийСтрокой;
	Иначе
		ВыбранныеФайлы = Настройки.ИмяФайлаОбновления;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПарольАдминистратора(ПараметрыАдминистрирования)
	
	АдминистраторИБ = ПользователиИнформационнойБазы.НайтиПоИмени(ПараметрыАдминистрирования.ИмяАдминистратораИнформационнойБазы);
	
	Если Не АдминистраторИБ.АутентификацияСтандартная Тогда
		
		АдминистраторИБ.АутентификацияСтандартная = Истина;
		АдминистраторИБ.Пароль = ПараметрыАдминистрирования.ПарольАдминистратораИнформационнойБазы;
		АдминистраторИБ.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти