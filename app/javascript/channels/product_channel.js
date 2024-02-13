import consumer from "channels/consumer";

document.addEventListener("turbo:load", () => {
  const productElement = document.getElementById("products-section");
  const productId = productElement.getAttribute("data-product-id");

  if (productId) {
    setupProductChannel(productId);
  }
});

function setupProductChannel(productId) {
  consumer.subscriptions.create(
    { channel: "ProductChannel", product_id: productId },
    {
      connected() {},
      disconnected() {},
      received(data) {
        switch (data.action) {
          case "new_bid":
            addNewBid(productId, data);
            break;
          case "bid_selected":
            handleBidSelected(data);
            break;
        }
      },
    }
  );
}

function addNewBid(productId, data) {
  const bidsElement = document.getElementById("bids");
  if (!bidsElement) return;

  const bidContainer = document.createElement("div");
  bidContainer.innerHTML = `<p>${data.email}: <strong>$${data.bid.price}</strong></p>`;

  if (isCurrentUserSeller()) {
    const selectButton = createSelectButton(data.bid.id, productId);
    bidContainer.appendChild(selectButton);
  }

  bidsElement.appendChild(bidContainer);
}

function handleBidSelected(data) {
  const productSection = document.getElementById("products-section");
  const bidsContainer = document.getElementById("bids");
  const bidForm = document.getElementById("bid-form");

  let soldOffContainer = document.getElementById("sold-off");
  if (!soldOffContainer) {
    soldOffContainer = document.createElement("div");
    soldOffContainer.setAttribute("id", "sold-off");
    productSection.insertBefore(soldOffContainer, bidsContainer);
  }

  soldOffContainer.innerHTML = `<p>Sold off to <strong>${data.email}</strong> for <strong>$${data.price}</strong></p><hr>`;

  if (bidsContainer) {
    bidsContainer.style.display = "none";
  }
  if (bidForm) {
    bidForm.style.display = "none";
  }
}

function createSelectButton(bidId, productId) {
  const selectButton = document.createElement("button");
  selectButton.textContent = "Select";
  selectButton.style.display = "block";
  selectButton.addEventListener("click", () => selectBid(bidId, productId));
  return selectButton;
}

function selectBid(bidId, productId) {
  fetch(`/products/${productId}/select_bid`, {
    method: "PATCH",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": document
        .querySelector("meta[name='csrf-token']")
        .getAttribute("content"),
    },
    body: JSON.stringify({ bid_id: bidId }),
  }).then((response) => {
    if (!response.ok) {
      console.error(response);
    }
  });
}

function isCurrentUserSeller() {
  const currentUserType = document.body.getAttribute("data-current-user-type");
  const currentUserId = document.body.getAttribute("data-current-user-id");
  const productUserId = document
    .getElementById("products-section")
    .getAttribute("data-product-user-id");

  return currentUserType === "seller" && currentUserId === productUserId;
}
