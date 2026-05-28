# EX_10 — Azure Cognitive Services Labs

In this exercise, you explore several **Microsoft Azure Cognitive Services / Azure AI services** through two connected labs. You will create Azure AI resources, run sample applications from Azure Cloud Shell, train simple custom models, and test computer vision, document intelligence, language, and speech capabilities.

You will:

- Create Azure Cognitive Services / Azure AI resources in the Azure portal
- Use **Computer Vision** to analyze images and extract descriptions, objects, and tags
- Use **Document Intelligence / Form Recognizer** to extract information from receipts
- Train and publish a **Custom Vision** image classification model
- Use **Computer Vision OCR** from Python to digitize handwritten notes
- Create a **Speech** resource and build a text-to-speech application with .NET
- Generate `.wav` files from plain text and SSML
- Create a **Language** resource and train a custom text classification model
- Test text classification from Cloud Shell
- Use Azure Speech REST API to recognize and convert speech to text

> Full instructions are in `EX_10_Instructions_1.pdf` and `EX_10_Instructions_2.pdf`.

---

## Platform

This lab uses **Microsoft Azure**.

Main Azure tools and services:

- Azure Portal
- Azure Cloud Shell / PowerShell
- Azure AI / Cognitive Services
- Computer Vision
- Document Intelligence / Form Recognizer
- Custom Vision
- Language Studio
- Speech service
- Azure Machine Learning Studio compute instance
- JupyterLab
- .NET console applications
- Python SDKs
- REST API calls with `curl`

Notes:

- Use the Azure region requested in each task, preferably **West Europe** where instructed.
- Keep your Azure resource keys and endpoints private.
- Several tasks require copying a service **key**, **endpoint**, **region**, **prediction URL**, or **prediction key** into scripts.
- Stop or delete resources when finished if you do not need them anymore.

---

## Lab 1 overview

`EX_10_Instructions_1.pdf` covers Azure Cognitive Services Lab 1.

Main tasks:

1. Analyse images with the Computer Vision service
2. Explore form recognition with Document Intelligence / Form Recognizer
3. Classify images with the Custom Vision service
4. Digitize handwritten notes with Azure Computer Vision and Python

---

## Lab 2 overview

`EX_10_Instructions_2.pdf` covers Azure Cognitive Services Lab 2.

Main tasks:

1. Create a text-to-speech application with Azure Speech
2. Create a custom text classification project with Azure Language service
3. Recognize and convert speech to text with Azure Speech REST API

---

## Required resources

Create or use the following Azure resources during the exercise:

```text
Computer Vision / Cognitive Services resource
Document Intelligence / Form Recognizer resource
Custom Vision / Cognitive Services resource
Speech resource
Storage account and blob container for custom text classification articles
Azure Machine Learning compute instance for the OCR Python notebook
```

Important values to save temporarily:

```text
Computer Vision key
Computer Vision endpoint
Document Intelligence key
Document Intelligence endpoint
Custom Vision prediction URL
Custom Vision prediction key
Speech key
Speech region
```

Do not commit keys or endpoints to GitHub.

---

## Lab workflow

1. Create a Computer Vision or Cognitive Services resource in Azure.
2. Open Azure Cloud Shell using PowerShell.
3. Clone the AI-900 sample repository.
4. Configure and run the image analysis script.
5. Test image analysis with the provided store images.
6. Modify the image analysis script to accept an image URL.
7. Test the modified script with your own internet image.
8. Create a Document Intelligence resource.
9. Configure and run the form recognizer script.
10. Modify the script to analyze a receipt from a URL.
11. Create a Custom Vision project for animal image classification.
12. Upload and tag animal training images.
13. Train, evaluate, and publish the Custom Vision model.
14. Run the Custom Vision client script from Cloud Shell.
15. Use Python and Azure Computer Vision SDK to extract text from a handwritten note.
16. Create a Speech resource.
17. Build a .NET text-to-speech console app.
18. Generate a `.wav` file from plain text.
19. Change the text-to-speech voice and create another output file.
20. Generate speech from an SSML file.
21. Use the Speech REST API to transcribe a `.wav` audio file.

---

## Task 1 — Computer Vision image analysis

Create a Computer Vision / Cognitive Services resource and save its key and endpoint.

Resource settings:

```text
Region: West Europe
Pricing tier: Standard S1
```

Clone the sample files in Azure Cloud Shell:

```powershell
git clone https://github.com/MicrosoftLearning/AI-900-AIFundamentals ai-900
cd ai-900
```

Open the sample script:

```powershell
code analyze-image.ps1
```

Replace the placeholders:

```powershell
$key="YOUR_KEY"
$endpoint="YOUR_ENDPOINT"
```

Run the provided image analysis examples:

```powershell
./analyze-image.ps1 store-camera-1.jpg
./analyze-image.ps1 store-camera-2.jpg
./analyze-image.ps1 store-camera-3.jpg
```

The output should include:

- Image description
- Detected objects
- Relevant tags

Create a URL-based version of the script:

```powershell
cp ./analyze-image.ps1 ./analyze-image-internet.ps1
code analyze-image-internet.ps1
```

Modify the beginning of the script so it accepts an image URL:

```powershell
param($img)
```

Run it with an online image URL:

```powershell
./analyze-image-internet.ps1 -img "IMAGE_URL_HERE"
```

---

## Task 2 — Document Intelligence / Form Recognizer

Create a Document Intelligence resource and save its key and endpoint.

Open the sample form recognizer script:

```powershell
cd ai-900
code form-recognizer.ps1
```

Replace the placeholders with your Document Intelligence credentials:

```powershell
$key="YOUR_KEY"
$endpoint="YOUR_ENDPOINT"
```

Run the sample receipt analysis:

```powershell
./form-recognizer.ps1
```

Then modify the script so it can accept a receipt image URL, similar to the Computer Vision URL task.

Try your own receipt image URL. English slip receipts usually work best.

Example URLs used in the instructions:

```text
https://e-racuni.com/Croatian/wiki-images/invoice_COMPLEX.jpg
https://upload.wikimedia.org/wikipedia/commons/0/0b/ReceiptSwiss.jpg
```

Expected output can include:

- Receipt type
- Merchant address
- Merchant phone
- Transaction date
- Receipt items
- Subtotal
- Tax
- Total

---

## Task 3 — Custom Vision image classification

Download and extract the animal image dataset:

```text
https://aka.ms/animal-images
```

The extracted folders should include:

```text
elephant
giraffe
lion
```

Create a project in the Custom Vision portal:

```text
Portal: https://customvision.ai
Project name: Animal Identification
Description: Image classification for animals
Project type: Classification
Classification type: Multiclass / Single tag per image
Domain: General [A2]
```

Upload images and assign tags:

```text
elephant -> tag: elephant
giraffe  -> tag: giraffe
lion     -> tag: lion
```

Train the model:

```text
Training type: Quick Training
```

Review model metrics:

- Precision
- Recall
- Average Precision / AP

Test with Quick Test:

```text
https://aka.ms/giraffe
```

Publish the model:

```text
Model name: animals
```

Keep the Prediction URL and Prediction Key open for the client script.

Update the Cloud Shell client:

```powershell
cd ai-900
code classify-image.ps1
```

Replace these placeholders:

```powershell
$predictionUrl="YOUR_PREDICTION_URL"
$predictionKey="YOUR_PREDICTION_KEY"
```

Run the client tests:

```powershell
./classify-image.ps1 1
./classify-image.ps1 2
./classify-image.ps1 3
```

Expected classes:

```text
1 -> giraffe
2 -> elephant
3 -> lion
```

---

## Task 4 — OCR handwritten notes with Python

Use the Azure Machine Learning compute instance from the previous Azure ML lab. Open JupyterLab and create a new notebook using the Python 3.10 AzureML kernel.

Install the Computer Vision SDK:

```python
!pip install azure-cognitiveservices-vision-computervision
```

Import libraries:

```python
from azure.cognitiveservices.vision.computervision import ComputerVisionClient
from msrest.authentication import CognitiveServicesCredentials
from azure.cognitiveservices.vision.computervision.models import OperationStatusCodes
from PIL import Image
import time
import os
```

Set your Computer Vision credentials:

```python
key = 'YOUR_KEY'
endpoint = 'YOUR_ENDPOINT'
```

Create the client:

```python
computervision_client = ComputerVisionClient(endpoint, CognitiveServicesCredentials(key))
```

Download the sample note image:

```python
!wget https://farm4.staticflickr.com/3789/10177514664_0ff9a53cf8_z.jpg -O note.jpg
```

Run the READ API workflow:

1. Submit an image to Computer Vision.
2. Wait for the analysis operation to complete.
3. Retrieve and print the detected text.

Student extension:

- Write a short note on paper.
- Take a photo of it.
- Upload it to an image hosting service.
- Use the real direct image URL.
- Run the OCR code on your own handwritten note.

---

## Task 5 — Text-to-speech with Azure Speech and .NET

Create a Speech service resource and save its key and region/location.

Create a .NET console application in Cloud Shell:

```bash
mkdir text-to-speech
cd text-to-speech
dotnet new console
dotnet add package Microsoft.CognitiveServices.Speech
```

Open the program file:

```bash
code Program.cs
```

Core using statements:

```csharp
using System.Text;
using Microsoft.CognitiveServices.Speech;
using Microsoft.CognitiveServices.Speech.Audio;
```

Plain text input file:

```text
Shakespeare.txt
```

Plain text output file:

```text
Shakespeare.wav
```

Run the app:

```bash
dotnet run
ls -l
```

Download the `.wav` file from Cloud Shell and listen to it locally.

Change the voice by adding this after `SpeechConfig.FromSubscription(...)`:

```csharp
speechConfig.SpeechSynthesisVoiceName = "en-SG-WayneNeural";
```

Use a different short text and a different output file name for the changed voice version.

---

## Task 6 — Text-to-speech with SSML

Create an SSML file:

```bash
code Shakespeare.xml
```

Basic SSML structure:

```xml
<speak xmlns="http://www.w3.org/2001/10/synthesis" version="1.0" xml:lang="en-US">
</speak>
```

Use SSML elements such as:

```text
<voice>    Choose different voices
<prosody>  Adjust rate and pitch
<break>    Add pauses
<phoneme>  Help pronunciation of difficult words
```

Example output file:

```text
Shakespeare2.wav
```

Update the .NET app to read the XML file and call:

```csharp
SpeakSsmlAsync(ssmlContent)
```

Run the app:

```bash
dotnet run
ls -l
```

Download and listen to the generated SSML audio file.

---


## Task 7 — Speech-to-text with Azure Speech REST API

Create an AI Foundry / Speech resource and save its key and region.

Use your own `.wav` file up to 60 seconds, or download the sample audio file:

```text
https://u.pcloud.link/publink/show?code=XZcejI5ZzvDP4ED8DGbqI01HptD6PRo8v07y
```

Set environment variables in Windows PowerShell or CMD:

```powershell
setx SPEECH_KEY "your-key"
setx SPEECH_REGION "your-region"
```

Restart the console window after setting the variables.

Run the REST API request with `curl`:

```powershell
curl --location --request POST "https://$env:SPEECH_REGION.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=en-US&format=detailed" --header "Ocp-Apim-Subscription-Key: $env:SPEECH_KEY" --header "Content-Type: audio/wav" --data-binary "@YourAudioFile.wav"
```

Expected response includes:

```json
{
  "RecognitionStatus": "Success",
  "DisplayText": "What's the weather like?"
}
```

---

## Student exercises

Complete and document at least several of the following practical extensions:

1. Analyze an internet image of your choice with Computer Vision.
2. Analyze at least one receipt image from a URL with Document Intelligence.
3. Test Custom Vision with an additional animal image URL not included in the lab.
4. Digitize your own handwritten note using the OCR notebook.
5. Create a new text-to-speech `.wav` file using a different voice and custom text.
6. Create an SSML file with at least two voices and at least one pause.
7. Transcribe a `.wav` audio file using the Speech REST API.

---

## Final submission

Submit your completed work by email.

Each student submits:

- Screenshot of the Azure resource group showing the created Azure AI resources
- Screenshot of Computer Vision image analysis output
- Screenshot of Document Intelligence receipt analysis output
- Screenshot of the Custom Vision project after training, showing model metrics
- Screenshot of Custom Vision prediction output from Cloud Shell
- Screenshot of the OCR notebook output for the sample note or your own note
- Screenshot or file evidence that `Shakespeare.wav` was generated
- Screenshot or file evidence that `Shakespeare2.wav` was generated from SSML
- Screenshot of Language Studio model deployment or model performance
- Screenshot of Speech-to-text REST API output showing `DisplayText`
- Short answer: Which Azure AI services did you use in this exercise?
- Short answer: What did Computer Vision detect in your chosen internet image?
- Short answer: What fields did Document Intelligence detect from your receipt?
- Short answer: How accurate was your Custom Vision model based on Precision, Recall, and AP?
- Short answer: What text was extracted from your handwritten note?
- Short answer: What did the Speech-to-text API recognize from the audio file?

Suggested email subject:

```text
Exercise 10 - Azure Cognitive Services - Your Name
```

Suggested submission file name:

```text
Exercise_10_Azure_Cognitive_Services_YourName.pdf
```

Students may submit:

- A PDF or Word document with screenshots and answers, or
- A zipped folder containing screenshots, generated audio files, and a short-answer document

Before sending, make sure:

- Your name is clearly written in the document or file name.
- Screenshots are readable.
- Keys and endpoints are hidden or blurred.
- Script outputs are visible in the screenshots.
- Generated `.wav` files are named clearly.
- Any shared links are accessible to the instructor.

---

## Files in this folder

- `EX_10_Instructions_1.pdf`
- `EX_10_Instructions_2.pdf`
- `README.md`
