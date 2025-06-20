# Variables
RESOURCE_GROUP="terraform-rg"
STORAGE_ACCOUNT="tfstateflaskapp"
CONTAINER_NAME="tfstateaws"
LOCATION="eastus"

# 📦 Create resource group
echo "📦 Creating resource group: $RESOURCE_GROUP..."
az group create --name "$RESOURCE_GROUP" --location "$LOCATION"

# Create Storage Account
echo "📁 Creating storage account: $STORAGE_ACCOUNT..."
az storage account create \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --encryption-services blob

# Get the access key
ACCOUNT_KEY=$(az storage account keys list \
  --resource-group "$RESOURCE_GROUP" \
  --account-name "$STORAGE_ACCOUNT" \
  --query '[0].value' -o tsv)

# Create the container for the state
echo "📂 Creating blob container: $CONTAINER_NAME..."
az storage container create \
  --name "$CONTAINER_NAME" \
  --account-name "$STORAGE_ACCOUNT" \
  --account-key "$ACCOUNT_KEY"

echo "✅ Storage backend ready"
