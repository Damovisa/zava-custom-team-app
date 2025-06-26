import { useState, useEffect, useRef } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetTrigger } from "@/components/ui/sheet";
import { Textarea } from "@/components/ui/textarea";
import { ScrollArea } from "@/components/ui/scroll-area";
import { AlertCircle, Lightbulb, PaperPlaneTilt, X } from "@phosphor-icons/react";
import { cn } from "@/lib/utils";
import { useKV } from '@github/spark/hooks';

type Message = {
  role: "user" | "assistant";
  content: string;
  timestamp: number;
};

export function DesignHelper() {
  const [messages, setMessages, deleteMessages] = useKV<Message[]>("design-helper-messages", []);
  const [input, setInput] = useState("");
  const [isProcessing, setIsProcessing] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  // Scroll to the bottom whenever messages change
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

  const sendMessage = async () => {
    if (!input.trim()) return;
    
    // Add user message
    setMessages((currentMessages) => [
      ...currentMessages,
      { role: "user", content: input.trim(), timestamp: Date.now() }
    ]);

    // Clear input
    setInput("");
    setIsProcessing(true);

    try {
      // Generate a prompt for the design helper AI
      const prompt = spark.llmPrompt`You are a clothing design assistant for Zava Athletics. 
      Help the user with clothing design tips and suggestions.
      Previous conversation: ${JSON.stringify(messages)}
      User message: ${input.trim()}
      Provide a helpful, concise response with specific design advice. Limit your response to 3-4 sentences.`;
      
      // Get response from AI
      const response = await spark.llm(prompt);
      
      // Add assistant message
      setMessages((currentMessages) => [
        ...currentMessages,
        { role: "assistant", content: response, timestamp: Date.now() }
      ]);
    } catch (error) {
      // Handle error
      setMessages((currentMessages) => [
        ...currentMessages,
        { 
          role: "assistant", 
          content: "Sorry, I'm having trouble processing your request right now. Please try again later.", 
          timestamp: Date.now() 
        }
      ]);
    } finally {
      setIsProcessing(false);
    }
  };

  const clearConversation = () => {
    if (window.confirm("Are you sure you want to clear this conversation?")) {
      deleteMessages();
    }
  };

  return (
    <Sheet>
      <SheetTrigger asChild>
        <Button variant="outline" size="icon" className="fixed z-50 top-20 right-6 rounded-full w-12 h-12 bg-primary text-primary-foreground shadow-md hover:shadow-lg">
          <Lightbulb weight="fill" size={24} />
        </Button>
      </SheetTrigger>
      <SheetContent className="w-full sm:w-[380px] sm:max-w-md flex flex-col p-0">
        <SheetHeader className="px-4 py-3 border-b flex flex-row justify-between items-center">
          <SheetTitle className="text-lg flex items-center gap-2">
            <Lightbulb weight="fill" size={20} className="text-primary" />
            Design Helper
          </SheetTitle>
          <Button variant="ghost" size="icon" onClick={clearConversation}>
            <X size={18} />
          </Button>
        </SheetHeader>

        {/* Messages area */}
        <ScrollArea className="flex-1 px-4 py-4">
          {messages.length === 0 ? (
            <div className="flex flex-col items-center justify-center h-full text-center text-muted-foreground p-4">
              <AlertCircle size={40} className="mb-4 opacity-50" />
              <p>No messages yet. Ask the design helper about color combinations, style advice, or personalization tips!</p>
            </div>
          ) : (
            <div className="space-y-4">
              {messages.map((message, index) => (
                <div
                  key={index}
                  className={cn(
                    "flex",
                    message.role === "user" ? "justify-end" : "justify-start"
                  )}
                >
                  <div
                    className={cn(
                      "max-w-[80%] rounded-lg px-4 py-3",
                      message.role === "user"
                        ? "bg-primary text-primary-foreground"
                        : "bg-muted"
                    )}
                  >
                    {message.content}
                  </div>
                </div>
              ))}
              <div ref={messagesEndRef} />
            </div>
          )}
          {isProcessing && (
            <div className="flex justify-start mt-4">
              <div className="bg-muted max-w-[80%] rounded-lg px-4 py-2">
                <div className="flex items-center space-x-2">
                  <div className="h-2 w-2 rounded-full bg-primary animate-pulse"></div>
                  <div className="h-2 w-2 rounded-full bg-primary animate-pulse delay-150"></div>
                  <div className="h-2 w-2 rounded-full bg-primary animate-pulse delay-300"></div>
                </div>
              </div>
            </div>
          )}
        </ScrollArea>

        {/* Input area */}
        <div className="border-t p-4">
          <div className="flex items-end gap-2">
            <Textarea 
              placeholder="Ask about design tips..."
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === "Enter" && !e.shiftKey) {
                  e.preventDefault();
                  sendMessage();
                }
              }}
              className="min-h-[60px] resize-none"
            />
            <Button 
              onClick={sendMessage} 
              disabled={isProcessing || !input.trim()}
              size="icon" 
              className="flex-shrink-0"
            >
              <PaperPlaneTilt size={18} weight="fill" />
            </Button>
          </div>
          <p className="text-xs text-muted-foreground mt-2">
            Ask about color combinations, design styles, or personalization ideas.
          </p>
        </div>
      </SheetContent>
    </Sheet>
  );
}