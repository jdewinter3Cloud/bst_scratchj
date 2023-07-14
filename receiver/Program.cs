//dotnet new console --language c#
//dotnet add package Azure.Messaging.ServiceBus

// https://stackoverflow.com/questions/62659336/azure-function-via-terraform-how-to-connect-to-service-bus
// https://stackoverflow.com/questions/74531111/how-to-create-an-azure-service-bus-namespace-instance-per-developer-using-terraf
// https://playwright.dev/dotnet/docs/pom

// modelled off of: https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-dotnet-how-to-use-topics-subscriptions?tabs=connection-string

// See https://aka.ms/new-console-template for more information
using Azure.Messaging.ServiceBus;

// See https://aka.ms/new-console-template for more information
Console.WriteLine("Hello, World!");

string connectionString = "Endpoint=sb://bst-test-sevicebusn01s.servicebus.windows.net/;SharedAccessKeyName=servicebus_listen_auth_rule;SharedAccessKey=6H9y6xZbSEvnQlIG4cqgeYfXG5/ZzW6ny+ASbLGON4s=";
string queueName = "y";


// handle received messages
async Task MessageHandler(ProcessMessageEventArgs args)
{
    string body = args.Message.Body.ToString();
    Console.WriteLine($"Received: {body} from subscription.");

    // complete the message. messages is deleted from the subscription. 
    await args.CompleteMessageAsync(args.Message);
}

// handle any errors when receiving messages
Task ErrorHandler(ProcessErrorEventArgs args)
{
    Console.WriteLine(args.Exception.ToString());
    return Task.CompletedTask;
}

ServiceBusClient? client = null;
try {
    client = new ServiceBusClient(connectionString);
    var processor = client.CreateProcessor(queueName, queueName, new ServiceBusProcessorOptions());
    try {

        processor.ProcessMessageAsync += MessageHandler;
        processor.ProcessErrorAsync += ErrorHandler;

        // start processing 
        await processor.StartProcessingAsync();

        Console.WriteLine("Wait for a minute and then press any key to end the processing");
        Console.ReadKey();


    } finally {
        if (processor != null) {
            Console.WriteLine("\nStopping the receiver...");
            await processor.StopProcessingAsync();
            Console.WriteLine("Stopped receiving messages");
            await processor.DisposeAsync();
        }
    }
} finally {
    if (client != null) {
        await client.DisposeAsync();    
    }
}
