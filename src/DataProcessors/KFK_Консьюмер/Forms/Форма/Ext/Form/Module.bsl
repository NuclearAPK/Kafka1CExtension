﻿&НаКлиенте
Перем КомпонентаСлушателя; 

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущийРежим = "Остановлено";  
	
	Если Параметры.Свойство("Консьюмер") Тогда
		ЗаполнитьЗначенияСвойств(Объект, Параметры, "Консьюмер, Брокер");
		КонсьюмерПриИзмененииНаСервере();
  		Элементы.Топик.СписокВыбора.ЗагрузитьЗначения(
			KFK_ИнтеграцияВызовСервера.ЗаполнитьСписокВыбораТопиков(Объект.Брокер).ВыгрузитьЗначения());  
		
		БрокерПриИзмененииНаСервере();	
	КонецЕсли;     
	
КонецПроцедуры  

&НаКлиенте
Асинх Процедура ПриОткрытии(Отказ)    
	
	ИдентификаторВК = KFK_ИнтеграцияВызовСервера.ИдентификаторВнешнейКомпоненты();
	Подключено = Ждать KFK_ИнтеграцияКлиент.ПодключитьКомпонентуКафка(ИдентификаторВК); 
	
	Отказ = (НЕ Подключено);
	
	Если НЕ Отказ Тогда
		Попытка
			КомпонентаСлушателя = Новый(СтрШаблон("AddIn.%1.simpleKafka1C", ИдентификаторВК));
		Исключение
			ВызватьИсключение "Компонента <Simple Kafka 1C> не подключена!";
		КонецПопытки; 		
	КонецЕсли;      
	
КонецПроцедуры

&НаКлиенте
Асинх Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ТекущийРежим = "Прослушивание" Тогда  		
		Ждать КомпонентаСлушателя.ОстановитьКонсьюмераАсинх();    
	КонецЕсли;
	
	КомпонентаСлушателя = Неопределено;  
	
КонецПроцедуры

#КонецОбласти //ОбработчикиСобытийФормы

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БрокерПриИзменении(Элемент) 
	
	Элементы.Топик.СписокВыбора.ЗагрузитьЗначения(
		KFK_ИнтеграцияВызовСервера.ЗаполнитьСписокВыбораТопиков(Объект.Брокер).ВыгрузитьЗначения());  
		
	БрокерПриИзмененииНаСервере();	

КонецПроцедуры  

Процедура БрокерПриИзмененииНаСервере()
	
	АдресБрокера = Объект.Брокер.АдресБрокера;
	ЗаполнитьПараметрыПодключения();
	
КонецПроцедуры

&НаКлиенте
Процедура КонсьюмерПриИзменении(Элемент)
	
	КонсьюмерПриИзмененииНаСервере();
	
КонецПроцедуры   

Процедура КонсьюмерПриИзмененииНаСервере()
	
	Объект.Брокер = Объект.Консьюмер.Брокер;     
	ПолучатьРезультатДвоичнымиДанными = Объект.Консьюмер.ПолучатьСообщенияДвоичнымиДанными;
	
	АдресБрокера = Объект.Брокер.АдресБрокера;
	ТаймаутОжиданияСообщений = Объект.Консьюмер.ТаймаутОжиданияСообщений; 
	ИдентификаторГруппы = Объект.Консьюмер.Идентификатор;  
	КаталогЛогов = Объект.Консьюмер.КаталогЛогов;
	
	Элементы.Топик.СписокВыбора.ЗагрузитьЗначения(
		KFK_ИнтеграцияВызовСервера.ЗаполнитьСписокВыбораТопиков(Объект.Брокер).ВыгрузитьЗначения());   
		
	Если Объект.Консьюмер.Топики.Количество() Тогда
		Объект.Топик = Объект.Консьюмер.Топики[0].Топик;		
	КонецЕсли;	
		
	ЗаполнитьПараметрыПодключения();	               
	
	Элементы.ПрочитанныеСообщенияСохранитьСообщение.Видимость = Объект.Консьюмер.ПолучатьСообщенияДвоичнымиДанными;
	
КонецПроцедуры     

Процедура ЗаполнитьПараметрыПодключения()
	
	ПараметрыПодключения.Очистить();
	
	Для каждого Параметр Из Объект.Брокер.ПараметрыПодключения Цикл
		ЗаполнитьЗначенияСвойств(ПараметрыПодключения.Добавить(), Параметр);	
	КонецЦикла;    
	
	Для каждого Параметр Из Объект.Консьюмер.ПараметрыКонсьюмера Цикл
		ЗаполнитьЗначенияСвойств(ПараметрыПодключения.Добавить(), Параметр);	
	КонецЦикла;            
	
	Параметр = ПараметрыПодключения.Добавить();     
	Параметр.Ключ = "group.id";
	Параметр.Значение = ИдентификаторГруппы;
			
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьПолученныеСообщения(Команда)
	Объект.ПрочитанныеСообщения.Очистить();
КонецПроцедуры

&НаКлиенте
Асинх Процедура ОбработчикПрослушиванияТопика()    
	
	Попытка       
		СообщениеПрочитано = Ждать КомпонентаСлушателя.ПрочитатьСообщениеАсинх();
	Исключение   
		ОписаниеОшибки = Ждать КомпонентаСлушателя.ПолучитьСообщениеОбОшибкеАсинх();
		КомпонентаСлушателя = Неопределено;                                                         
		ВызватьИсключение ОписаниеОшибки() + " " + ОписаниеОшибки;
	КонецПопытки;		   
	
	Если НЕ СообщениеПрочитано.Значение Тогда
		Возврат;
	КонецЕсли; 
	
	Сообщение 	= Ждать КомпонентаСлушателя.ПолучитьДанныеСообщенияАсинх(ПолучатьРезультатДвоичнымиДанными); // сообщение как оно есть (если передать Истина), если не указывать параметр - возвращается строка UTF-8
	Ключ 		= Ждать КомпонентаСлушателя.ПолучитьКлючСообщенияАсинх();
	Заголовки 	= Ждать КомпонентаСлушателя.ПолучитьЗаголовкиСообщенияАсинх();
	БрокерИд 	= Ждать КомпонентаСлушателя.ПолучитьИдентификаторБрокераСообщенияАсинх();
	ВременнаяМетка 	= Ждать КомпонентаСлушателя.ПолучитьВременнуюМеткуСообщенияАсинх();
	Партиция 	= Ждать КомпонентаСлушателя.ПолучитьРазделСообщенияАсинх();
	Смещение 	= Ждать КомпонентаСлушателя.ПолучитьСмещениеСообщенияАсинх();   
	
	СтрокаДанных = Объект.ПрочитанныеСообщения.Добавить();
	СтрокаДанных.Сообщение = Сообщение.Значение;
	СтрокаДанных.Ключ = Ключ.Значение;
	СтрокаДанных.Заголовки = Заголовки.Значение;
	СтрокаДанных.ВременнаяМетка = ВременнаяМетка.Значение;
	СтрокаДанных.Смещение = Смещение.Значение;
	СтрокаДанных.Партиция = Партиция.Значение;     
	
	Если ПолучатьРезультатДвоичнымиДанными Тогда
		СтрокаДанных.АдресДвоичныхДанных = ПоместитьВоВременноеХранилище(Сообщение.Значение, УникальныйИдентификатор);	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти //ОбработчикиСобытийЭлементовШапкиФормы

#Область ОбработчикиКомандФормы

&НаКлиенте
Асинх Процедура СлушатьСообщения(Команда)      
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;       
	
	ТекстВопроса = ?(ТекущийРежим = "Прослушивание", "Остановить прослушивание?", "Начать прослушивание?");
	
    Режим = РежимДиалогаВопрос.ДаНет;
    Ответ = Ждать ВопросАсинх(ТекстВопроса, Режим, 0);
	
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;	
	
	Если ТекущийРежим = "Остановлено" Тогда
		ЗапуститьПрослушиваниеТопикаНаКлиенте();    
		
		ТекущийРежим = "Прослушивание";	 
		Элементы.ФормаСлушатьСообщения.Заголовок = "Остановить";  
	Иначе
		ОстановитьПрослушиваниеТопикаНаКлиенте();        
		
		ТекущийРежим = "Остановлено";
		Элементы.ФормаСлушатьСообщения.Заголовок = "Слушать сообщения"; 
	КонецЕсли;             	
	
КонецПроцедуры    

&НаКлиенте
Асинх Процедура СохранитьСообщение(Команда)  
	
	ТекущиеДанные = Элементы.ПрочитанныеСообщения.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;	
	КонецЕсли;       
	
	АдресФайла = ТекущиеДанные.АдресДвоичныхДанных;

	Если НЕ ЗначениеЗаполнено(АдресФайла) Тогда
		ПоказатьПредупреждение(, "В хранилище отсутствуют двоичные данные! Сохранение невозможно");	
		Возврат;
	КонецЕсли;
	
	ПараметрыДиалога = Новый ПараметрыДиалогаПолученияФайлов;
	ПараметрыДиалога.Заголовок = "Укажите куда сохранить файл";
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Ключ) Тогда
		ИмяФайла = СтрШаблон("%1 offset-%2 partition-%3 key-%4.bin", Объект.Топик, ТекущиеДанные.Смещение, ТекущиеДанные.Партиция, ТекущиеДанные.Ключ); 
	Иначе
		ИмяФайла = СтрШаблон("%1 offset-%2 partition-%3.bin", Объект.Топик, ТекущиеДанные.Смещение, ТекущиеДанные.Партиция); 		
	КонецЕсли;
	
	Результат = Ждать ПолучитьФайлССервераАсинх(АдресФайла, ИмяФайла, ПараметрыДиалога); 	

КонецПроцедуры

#КонецОбласти //ОбработчикиКомандФормы

#Область СлужебныеПроцедурыИФункции  

&НаКлиенте
Асинх Процедура ЗапуститьПрослушиваниеТопикаНаКлиенте()
		
	Для каждого Параметр Из ПараметрыПодключения Цикл
		Ждать КомпонентаСлушателя.УстановитьПараметрАсинх(СокрЛП(Параметр.Ключ), СокрЛП(Параметр.Значение));	
	КонецЦикла;
	
	Ждать КомпонентаСлушателя.УстановитьКаталогЛоговАсинх(КаталогЛогов);
	
	Результат = Ждать КомпонентаСлушателя.ИнициализироватьКонсьюмераАсинх(АдресБрокера);
	
	Если НЕ Результат.Значение Тогда 
		СообщениеОбОшибке = Ждать КомпонентаСлушателя.ПолучитьСообщениеОбОшибкеАсинх();
		ВызватьИсключение СообщениеОбОшибке.Значение;
	КонецЕсли;
	
	РезультатПодписки = Ждать КомпонентаСлушателя.ПодписатьсяАсинх(Объект.Топик);   

	Если НЕ Результат.Значение Тогда 
		СообщениеОбОшибке = Ждать КомпонентаСлушателя.ПолучитьСообщениеОбОшибкеАсинх();
		ВызватьИсключение СообщениеОбОшибке.Значение;
	КонецЕсли;
		
	Если Результат.Значение Тогда                                
		Ждать КомпонентаСлушателя.УстановитьТаймаутОжиданияАсинх(ТаймаутОжиданияСообщений);	
		ПодключитьОбработчикОжидания("ОбработчикПрослушиванияТопика", 1);   
	Иначе                 
		СообщениеОбОшибке = Ждать КомпонентаСлушателя.ПолучитьСообщениеОбОшибкеАсинх();
		ВызватьИсключение СообщениеОбОшибке.Значение;	
	КонецЕсли;
	
КонецПроцедуры  

&НаКлиенте
Асинх Процедура ОстановитьПрослушиваниеТопикаНаКлиенте()   
	
	ОтключитьОбработчикОжидания("ОбработчикПрослушиванияТопика");  
	
	Ждать КомпонентаСлушателя.ОстановитьКонсьюмераАсинх();    
	
	КомпонентаСлушателя = Неопределено;
	
КонецПроцедуры     

#КонецОбласти
