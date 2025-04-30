return {
	UI = {
		currency = "$",
		main = {
			item = {
				addCart = "Add To Cart",
			},
		},
		cart = {
			payment = {
				title = "Payment",
				payBank = "Bank",
				payCash = "Cash",
			},
		},
	},

	Interaction = {
		HelpText = "~INPUT_CONTEXT~  View Product Catalog", --? Button Reference: https://docs.fivem.net/docs/game-references/controls
		FloatingText = "~INPUT_CONTEXT~ View Product Catalog", --? Button Reference: https://docs.fivem.net/docs/game-references/controls
		Target = {
			Icon = "fa-solid fa-cart-shopping", --? Icon Reference: https://fontawesome.com/icons
			Label = "View Product Catalog",
		},
	},

	Dialog = {
		License = {
			Header = "A **%s** is required to access this shop!",
			Content = "Would you like to purchase a **%s** for **$%s**?",
		},
	},

	Notify = {
		Requirement = {
			Job = { title = "Access Requirement", description = "The **%s** job is required to access this shop!", type = "warning" },
			JobGrade = { title = "Access Requirement", description = "Your job grade doesn't meet the requirements to access this shop!.", type = "warning" },
			License = { title = "Access Requirement", description = "A **%s** is required to access this shop!", type = "warning" },
		},
		CantCarry = {
			Item = { title = "Carry Restriction", description = "You cannot carry the **%s**.", type = "error" },
			Weapons = { title = "Carry Restriction", description = "You cannot carry multiple **%s*'s*.", type = "error" },
		},
		NoMoney = {
			Shop = { title = "Insufficient Funds", description = "You do not have enough money to pay for your purchase.", type = "error" },
			License = { title = "Insufficient Funds", description = "You don't have enough money to buy the **%s**.", type = "error" },
		},
		PaymentSuccess = {
			Shop = { title = "Purchase Complete", description = "Successfully purchased item(s) for **$%s**.", type = "success" },
			License = { title = "Purchase Complete", description = "Successfully purchased a **%s** for **$%s**.", type = "success" },
		},
	},
}
