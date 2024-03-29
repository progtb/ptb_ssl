﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПользовательСсылка = ТекущийПользовательНаСервере();
	Если НЕ ЗначениеЗаполнено(ПользовательСсылка) Тогда
		ПоказатьПредупреждение(, НСтр("ru='Текущий пользователь не определен.'")); 
		Возврат;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Пользователь", ПользовательСсылка);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбора);
	
	ОткрытьФорму("РегистрСведений.НастройкиИнтеграцииConfluence.ФормаСписка",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);

КонецПроцедуры

&НаСервере 
Функция ТекущийПользовательНаСервере()
	Возврат Пользователи.ТекущийПользователь();
КонецФункции