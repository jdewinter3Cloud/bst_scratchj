// See https://aka.ms/new-console-template for more information
using Azure.Messaging.ServiceBus;

string connectionString = "Endpoint=sb://bst-test-sevicebusn01s.servicebus.windows.net/;SharedAccessKeyName=servicebus_send_auth_rule;SharedAccessKey=SfIaT1QZHE/GzLoPvoMXPUG0VgMye49Hq+ASbG0s+lw=";
string queueName = "y";

Console.WriteLine("Hello, World!");

await using var client = new ServiceBusClient(connectionString);

ServiceBusSender sender = client.CreateSender(queueName);
ServiceBusMessage message = new ServiceBusMessage("Hello world!");

try
{
    await sender.SendMessageAsync(message);
}
finally
{
    await sender.DisposeAsync();
    await client.DisposeAsync();
}