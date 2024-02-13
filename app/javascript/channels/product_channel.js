import consumer from "channels/consumer";

document.addEventListener("turbo:load", () => {
  const productElement = document.getElementById("products-section");
  const productId = productElement.getAttribute("data-product-id");
  const currentUserId = document.body.getAttribute("data-current-user-id");
  const currentUserType = document.body.getAttribute("data-current-user-type");
  const productUserId = productElement.getAttribute("data-product-user-id");

  if (productId) {
    consumer.subscriptions.create(
      { channel: "ProductChannel", product_id: productId },
      {
        connected() {
          // Called when the subscription is ready for use on the server
        },

        disconnected() {
          // Called when the subscription has been terminated by the server
        },

        received(data) {
          const bidsElement = document.getElementById("bids");
          if (data.action === "new_bid") {
            if (bidsElement) {
              // Create a container for the bid and the button
              const bidContainer = document.createElement("div");

              const newBidText = document.createElement("p");
              newBidText.innerHTML = `${data.email}: $${data.bid.price}`;
              bidContainer.appendChild(newBidText);
              if (
                currentUserType === "seller" &&
                currentUserId === productUserId
              ) {
                const selectButton = document.createElement("button");
                selectButton.textContent = "Select";
                selectButton.setAttribute("data-bid-id", data.bid.id);
                selectButton.style.display = "block";
                selectButton.addEventListener("click", function () {
                  fetch(`/products/${productId}/select_bid`, {
                    method: "PATCH",
                    headers: {
                      "Content-Type": "application/json",
                      "X-CSRF-Token": document
                        .querySelector("meta[name='csrf-token']")
                        .getAttribute("content"),
                    },
                    body: JSON.stringify({ bid_id: data.bid.id }),
                  }).then((response) => {
                    if (response.ok) {
                      window.location.reload();
                    }
                  });
                });
                bidContainer.appendChild(selectButton);
              }

              bidsElement.appendChild(bidContainer);
            }
          } else if (data.action === "bid_selected") {
            if (bidsElement) {
              bidsElement.innerHTML = `<p><strong>Sold off to ${data.email} for $${data.price}</strong></p>`;
              // Optionally, disable the bidding form if present
              const bidForm = document.getElementById("bid-form");
              if (bidForm) {
                bidForm.style.display = "none";
              }
            }
          }
        },
      }
    );
  }
});
