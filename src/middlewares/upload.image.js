import multer from 'multer'
import sharp from 'sharp'

const storage = multer.memoryStorage()
const upload = multer({ storage: storage })

app.post('/posts', upload.single('image'), async (req, res) => {
    const file = req.file
    const caption = req.body.caption

    const fileBuffer = await sharp(file.buffer)
        .resize({ height: 1920, width: 1080, fit: "contain" })
        .toBuffer()

    })