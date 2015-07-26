package com.evili.worldBuilder.Commands
{
	public class ContextMenuInvoker
	{
		private var command:ICommand;
		
		public function ContextMenuInvoker()
		{
		}
		public function setCommand(command:ICommand):void{
			this.command = command;
		}
		public function issueCommand():void{
			this.command.execute();
		}
	}
}