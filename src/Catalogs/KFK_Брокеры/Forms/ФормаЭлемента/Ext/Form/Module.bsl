﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПолучитьСписокТопиковБрокера();    
	КонецЕсли;
	
КонецПроцедуры  

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если ПодключитьсяКБрокеру Тогда
		ПолучитьСписокТопиковБрокера();   
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти          

#Область ОбработчикиКомандФормы

&НаКлиенте
Асинх Процедура ЗаписатьПереопеределяемая(Команда)
	
	Если ЗначениеЗаполнено(Объект.АдресБрокера) И ТопикиБрокера.Количество() = 0 И 
		Модифицированность Тогда      
		
		Если НЕ ПроверитьЗаполнение() Тогда
			Возврат;
		КонецЕсли; 
		
		Режим = РежимДиалогаВопрос.ДаНет;
		Ответ = Ждать ВопросАсинх(НСтр("ru = 'Подключиться к брокеру?';"
			+ " en = 'Connect to broker?'"), Режим, 0);
			
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			ПодключитьсяКБрокеру = Ложь;  
		Иначе
			ПодключитьсяКБрокеру = Истина; 	
		КонецЕсли;			   
		
		Записать();
	КонецЕсли;      
	
КонецПроцедуры

&НаКлиенте
Асинх Процедура ЗагрузитьНастройкиИзФайла(Команда) 
	
	Режим = РежимДиалогаВыбораФайла.Открытие;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	Фильтр = "Файл настроек (*.*)|*.*";
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = "Выберите файл настроек";
	
	РезультатВыбора = Ждать ДиалогОткрытияФайла.ВыбратьАсинх();
	
	АдресФайла = "";
	
	Если РезультатВыбора <> Неопределено И ТипЗнч(РезультатВыбора) = Тип("Массив") Тогда
		Для каждого ВыбранныйФайл Из РезультатВыбора Цикл
			АдресФайла = ВыбранныйФайл;		
		КонецЦикла;
	КонецЕсли;                         
	
	Если ЗначениеЗаполнено(АдресФайла) Тогда
		
		Объект.ПараметрыПодключения.Очистить();
		
		ТекстНастроек = Новый ТекстовыйДокумент;
		Ждать ТекстНастроек.ПрочитатьАсинх(АдресФайла);         
		
		КоличествоСтрок = ТекстНастроек.КоличествоСтрок();
		Для к = 1 по КоличествоСтрок Цикл
			ДанныеНастроек = СтрРазделить(ТекстНастроек.ПолучитьСтроку(к), Символы.Таб);
			Если ДанныеНастроек.Количество() = 2 Тогда
				СтрокаНастроек = Объект.ПараметрыПодключения.Добавить();
				СтрокаНастроек.Ключ = ДанныеНастроек[0];
				СтрокаНастроек.Значение = ДанныеНастроек[1];	
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;         
	
	Если Объект.ПараметрыПодключения.Количество() Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти                       

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТопикиБрокераВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	// здесь будет открытие формы
	KFK_ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Функционал открытия карточки топика временно недоступен!");
КонецПроцедуры

&НаКлиенте
Асинх Процедура АдресБрокераНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка) 
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Режим = РежимДиалогаВопрос.ДаНет;
	Ответ = Ждать ВопросАсинх(НСтр("ru = 'Подключиться к брокеру?';"
		+ " en = 'Connect to broker?'"), Режим, 0);
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;	          
	
	ПолучитьСписокТопиковБрокера();    
	
	Если ТопикиБрокера.Количество() Тогда
		ПоказатьПредупреждение(Неопределено, "Подключение к брокеру успешно произведено", 15, "Внимание");	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПолучитьСписокТопиковБрокера()
	
	ДополнительныеПараметры = Новый Структура("ПараметрыПодключения", Новый Соответствие);
	
	Для каждого Параметр Из Объект.ПараметрыПодключения Цикл
		ДополнительныеПараметры.ПараметрыПодключения.Вставить(Параметр.Ключ, Параметр.Значение);
	КонецЦикла;
	
	ТопикиБрокера.Загрузить(KFK_Интеграция.ПолучитьДанныеТопиковБрокера(Объект.АдресБрокера, ДополнительныеПараметры));
	
КонецПроцедуры  

#КонецОбласти